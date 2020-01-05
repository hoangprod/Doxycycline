local EDIT_OFFSET = 10
function ApplyEditDialogStyle(wnd, defaultInputText, guideTip, autoTextChange, applyNamePolicy, enableCheckFunc)
  wnd:SetUILayer("dialog")
  local editbox = W_CTRL.CreateEdit("editbox", wnd)
  editbox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, DEFAULT_SIZE.EDIT_HEIGHT)
  local namePolicyInfo = X2Util:GetNamePolicyInfo(applyNamePolicy)
  editbox:SetMaxTextLength(namePolicyInfo.max)
  if guideTip ~= nil then
    local guide = wnd:CreateChildWidget("textbox", "guide", 0, true)
    guide:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH + 10)
    guide:SetAutoResize(true)
    if namePolicyInfo ~= nil then
      guide:SetText(F_TEXT.GetLimitInfoText(namePolicyInfo))
    else
      guide:SetText(guideTip)
    end
    guide:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, EDIT_OFFSET / 2)
    guide.style:SetFontSize(FONT_SIZE.SMALL)
    ApplyTextColor(guide, FONT_COLOR.GRAY)
    editbox:AddAnchor("TOP", guide, "BOTTOM", 0, 7)
  else
    editbox:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, EDIT_OFFSET / 2)
  end
  wnd:RegistBottomWidget(editbox)
  function wnd:ShowProc()
    if defaultInputText == nil or string.len(defaultInputText) == 0 then
      wnd.btnOk:Enable(false)
    end
    if defaultInputText ~= nil then
      self.editbox:SetText(defaultInputText)
    end
    self.editbox:SetFocus()
  end
  local function OnEnterPressed()
    if not wnd.btnOk:IsEnabled() then
      return
    end
    if wnd.OkProc ~= nil then
      wnd:OkProc()
    end
    F_SOUND.PlayUISound(wnd:GetOkSound(), true)
    X2DialogManager:OnOK(wnd:GetId())
  end
  wnd.editbox:SetHandler("OnEnterPressed", OnEnterPressed)
  local function OnEscapePressed()
    if wnd.CancelProc ~= nil then
      wnd:CancelProc()
    end
    X2DialogManager:OnCancel(wnd:GetId())
  end
  wnd.editbox:SetHandler("OnEscapePressed", OnEscapePressed)
  local function OnTextChanged()
    if autoTextChange then
      local namePolicy
      if applyNamePolicy == nil then
        namePolicy = VNT_END
      else
        namePolicy = applyNamePolicy
      end
      editbox:CheckNamePolicy(namePolicy)
    end
    local isEnable = false
    if applyNamePolicy ~= nil then
      isEnable = X2Util:IsValidName(wnd.editbox:GetText(), applyNamePolicy)
    end
    if enableCheckFunc ~= nil and not enableCheckFunc(wnd) then
      isEnable = false
    end
    wnd.btnOk:Enable(isEnable)
  end
  wnd.editbox:SetHandler("OnTextChanged", OnTextChanged)
end
local EditTitleFunc = function(argTable)
  local function DialogDefaultHandler(wnd, infoTable)
    ApplyEditDialogStyle(wnd, argTable.defaultInputText, argTable.guideTip, argTable.autoTextChange, argTable.applyNamePolicy, argTable.enableCheckFunc)
    if argTable.addedFunc ~= nil then
      argTable.addedFunc(wnd)
    end
    function wnd:OkProc()
      local newName = wnd.editbox:GetText()
      argTable.okProc(newName, argTable.otherInfo)
    end
    wnd:SetTitle(argTable.title)
    wnd:SetContent(argTable.content)
  end
  if argTable.ownerWnd == nil then
    X2DialogManager:RequestDefaultDialog(DialogDefaultHandler, "")
  else
    X2DialogManager:RequestDefaultDialog(DialogDefaultHandler, argTable.ownerWnd:GetId())
  end
end
function ShowChangeMateName(target, ownerWnd)
  if target == "target" and X2Unit:GetTargetUnitId() == nil then
    return
  end
  local unitId = X2Unit:GetUnitId(target)
  local mateType = X2Unit:GetUnitMateType(target)
  local function func(newName)
    X2Mate:SetMateName(mateType, newName)
  end
  local argTable = {
    title = locale.common.changeName,
    content = locale.changeName.change_content_guide,
    otherInfo = nil,
    ownerWnd = ownerWnd,
    autoTextChange = true,
    applyNamePolicy = VNT_SUMMONS,
    defaultInputText = X2Unit:GetUnitNameById(unitId),
    guideTip = locale.changeName.name_guide_default,
    okProc = func
  }
  EditTitleFunc(argTable)
end
function ShowChangeSlaveName(target, ownerWnd)
  if target == "target" and X2Unit:GetTargetUnitId() == nil then
    return
  end
  local unitId = X2Unit:GetUnitId(target)
  local func = function(newName)
    X2SiegeWeapon:SetSiegeWeaponName(newName)
  end
  local argTable = {
    title = locale.common.changeName,
    content = locale.changeName.change_content_guide,
    ownerWnd = ownerWnd,
    otherInfo = nil,
    autoTextChange = true,
    applyNamePolicy = VNT_SUMMONS,
    defaultInputText = X2Unit:GetUnitNameById(unitId),
    guideTip = locale.changeName.name_guide_default,
    okProc = func
  }
  EditTitleFunc(argTable)
end
function HideEditDialog(ownerWnd)
  X2DialogManager:DeleteByOwnerWindow(ownerWnd:GetId())
end
function ShowChangeFamilyAppellation(target, infoTable)
  local func = function(newAppellation, otherInfo)
    X2Family:ChangeTitle(otherInfo, newAppellation)
  end
  local argTable = {
    title = locale.family.changeTitle,
    content = locale.family.inputGuide,
    ownerWnd = infoTable[1],
    otherInfo = infoTable[2],
    autoTextChange = false,
    applyNamePolicy = VNT_FAMILY_TITLE,
    defaultInputText = infoTable[3],
    guideTip = locale.changeName.name_guide_family_appellation,
    okProc = func
  }
  EditTitleFunc(argTable)
end
function ShowChangeHousingName(ownerWnd)
  local func = function(newName)
    X2House:SetHouseName(newName)
  end
  local argTable = {
    title = locale.housing.maintainWindow.changeName,
    content = locale.changeName.change_content_guide,
    ownerWnd = ownerWnd,
    applyNamePolicy = VNT_SUMMONS,
    autoTextChange = true,
    defaultInputText = X2House:GetHouseName(),
    guideTip = locale.changeName.name_guide_default,
    okProc = func
  }
  EditTitleFunc(argTable)
end
function ShowRenameCharacter(charIndex, name)
  local function doOk(newName)
    local function DialogHandler(wnd)
      wnd:SetTitle(locale.characterSelect.renameConfirm.title)
      wnd:SetContent(string.format([[
%s%s
%s]], FONT_COLOR_HEX.BLUE, newName, locale.characterSelect.renameConfirm.desc(FONT_COLOR_HEX.RED)))
      function wnd:OkProc()
        X2LoginCharacter:RenameCharacter(charIndex, newName)
      end
      function wnd:CancelProc()
        ShowRenameCharacter(charIndex, name)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "")
  end
  local argTable = {
    title = locale.characterSelect.renameCharacter.title,
    content = locale.characterSelect.renameCharacter.desc,
    ownerWnd = nil,
    applyNamePolicy = VNT_CHAR,
    autoTextChange = true,
    defaultInputText = "",
    guideTip = locale.changeName.name_guide_default,
    okProc = doOk
  }
  EditTitleFunc(argTable)
end
function ShowChangeChatTabName(tabId)
  local function func(newName)
    X2Chat:RenameChatTabByUser(tabId, newName)
  end
  local tabInfo = X2Chat:GetChatTabInfoTable(tabId)
  local argTable = {
    title = locale.common.changeName,
    content = locale.changeName.change_content_guide,
    ownerWnd = nil,
    applyNamePolicy = VNT_CHAT_TAB,
    autoTextChange = false,
    defaultInputText = tostring(tabInfo.name),
    guideTip = locale.changeName.name_guide_chat_tab,
    okProc = func
  }
  EditTitleFunc(argTable)
end
function ShowCreateChatTabName(windowId)
  local function func(newName)
    X2Chat:AddNewChatTabByUser(windowId, newName)
  end
  local argTable = {
    title = locale.chat.createTab,
    content = locale.changeName.create_content_guide,
    ownerWnd = nil,
    applyNamePolicy = VNT_CHAT_TAB,
    autoTextChange = false,
    defaultInputText = "",
    guideTip = locale.changeName.name_guide_chat_tab,
    okProc = func
  }
  EditTitleFunc(argTable)
end
local lastCreateName
function ShowCreateCharacter()
  local isEdit = X2LoginCharacter:IsRecustomizing()
  local isPreSelect = X2World:IsPreSelectCharacterPeriod()
  local function EditNameFunc(name)
    local characterInfo = {name = name}
    lastCreateName = name
    X2LoginCharacter:ApplyEditCharacter(characterInfo)
  end
  local function CreateNameFunc(name)
    local characterInfo = {name = name}
    lastCreateName = name
    X2LoginCharacter:NewCharacter(characterInfo)
  end
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local argTable = {}
  argTable.content = string.format([[
%s
%s]], GetUIText(CHARACTER_CREATE_TEXT, "makeName"), F_TEXT.GetLimitInfoText(namePolicyInfo))
  argTable.ownerWnd = nil
  argTable.applyNamePolicy = VNT_CHAR
  argTable.autoTextChange = true
  argTable.guideTip = nil
  if lastCreateName ~= nil then
    argTable.defaultInputText = lastCreateName
  else
    argTable.defaultInputText = ""
  end
  if isEdit then
    argTable.title = locale.characterCreate.confirmEditTitle
    if argTable.defaultInputText == "" then
      argTable.defaultInputText = X2LoginCharacter:GetEditUnitName()
    end
    argTable.okProc = EditNameFunc
  else
    argTable.title = locale.characterCreate.confirmCreateTitle
    argTable.okProc = CreateNameFunc
    if isPreSelect then
      argTable.content = string.format([[
%s
%s%s
%s]], argTable.content, FONT_COLOR_HEX.RED, GetCommonText("warning_to_create"), GetCommonText("pre_select_period_character_notice"))
    else
      argTable.content = string.format([[
%s
%s%s
%s]], argTable.content, FONT_COLOR_HEX.RED, GetCommonText("warning_to_create"), GetCommonText("cannot_change_character_name"))
    end
  end
  EditTitleFunc(argTable)
end
function ShowDeleteCharacter(ownerWnd, charIndex)
  local function DelteFunc(name)
    X2LoginCharacter:DeleteCharacterCheckName(charIndex, name)
  end
  local argTable = {
    title = locale.login.delete.title,
    content = locale.login.delete.label,
    ownerWnd = nil,
    applyNamePolicy = VNT_CHAR,
    autoTextChange = true,
    defaultInputText = "",
    guideTip = nil,
    okProc = DelteFunc
  }
  EditTitleFunc(argTable)
end
function ShowRegisterPotal(ownerWnd)
  local RegisterPortal = function(name)
    X2Warp:SavePortal(name)
  end
  local argTable = {
    title = locale.portal.addPortal,
    content = locale.changeName.register_content_guide,
    ownerWnd = ownerWnd,
    applyNamePolicy = VNT_PORTAL,
    defaultInputText = "",
    autoTextChange = false,
    guideTip = locale.changeName.name_guide_portal,
    okProc = RegisterPortal
  }
  EditTitleFunc(argTable)
end
function ShowChangePortalName(ownerWnd, portalId, portalName)
  local function ChangeName(name)
    X2Warp:RenamePortal(portalId, name)
  end
  local argTable = {
    title = locale.common.changeName,
    content = locale.changeName.change_content_guide,
    ownerWnd = ownerWnd,
    applyNamePolicy = VNT_PORTAL,
    autoTextChange = false,
    defaultInputText = portalName,
    guideTip = locale.changeName.name_guide_portal,
    okProc = ChangeName
  }
  EditTitleFunc(argTable)
end
function ShowCustomSaveName(ownerWnd, systemAlertWindow)
  local function func(fileName)
    if fileName == "" then
      systemAlertWindow:HandleResult(CDR_ERROR_AS_NO_FILE_NAME)
    else
      local result = X2Customizer:FindCustomSameNameFile(fileName)
      if result == CDR_INVALID_RESULT then
        local rlt, savePath = X2Customizer:SaveCustomData(fileName)
        if rlt == CDR_SAVE_SUCCESS then
          fileName = savePath
        end
        result = rlt
      end
      systemAlertWindow:HandleResult(result, fileName)
    end
  end
  local argTable = {
    title = locale.customSaveLoad.customSave,
    content = locale.customSaveLoad.customSaveContent,
    otherInfo = nil,
    ownerWnd = ownerWnd,
    autoTextChange = true,
    applyNamePolicy = VNT_CHAR,
    defaultInputText = nil,
    guideTip = true,
    okProc = func
  }
  EditTitleFunc(argTable)
end
function ShowExpeditionDelegate(ownerWnd)
  local ChangeExpeditionOwner = function(name)
    X2Faction:ChangeExpeditionOwner(name)
  end
  local argTable = {
    title = locale.expedition.delegateTitle,
    content = locale.expedition.delegateMsg,
    ownerWnd = ownerWnd,
    applyNamePolicy = VNT_CHAR,
    autoTextChange = false,
    defaultInputText = "",
    guideTip = nil,
    okProc = ChangeExpeditionOwner
  }
  EditTitleFunc(argTable)
end
function ShowNationDelegate(ownerWnd)
  local ChangeNationOwner = function(name)
    X2Faction:ChangeNationOwner(name)
  end
  local function AddedFunc(wnd)
    local itemType = X2Faction:GetNationOwnerChangeItem()
    local curCnt = X2Bag:GetCountInBag(itemType)
    local needCnt = X2Faction:GetNationOwnerChangeItemCount()
    wnd.editbox:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, EDIT_OFFSET)
    local str = string.format("%s/%s", tostring(curCnt), tostring(needCnt))
    local itemIcon = CreateItemIconButton(wnd:GetId() .. ".itemIcon", wnd)
    itemIcon:AddAnchor("TOP", wnd.editbox, "BOTTOM", 0, 15)
    wnd.itemIcon = itemIcon
    local itemTextbox = wnd:CreateChildWidget("textbox", "itemTextbox", 0, true)
    itemTextbox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
    itemTextbox.style:SetAlign(ALIGN_CENTER)
    itemTextbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
    ApplyTextColor(itemTextbox, FONT_COLOR.TITLE)
    itemTextbox:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 5)
    local itemInfo = X2Item:GetItemInfoByType(itemType)
    itemIcon:SetItemInfo(itemInfo)
    itemIcon:SetStack(curCnt, needCnt)
    wnd.itemTextbox:SetText(itemInfo.name)
    wnd:RegistBottomWidget(itemTextbox)
    if tonumber(curCnt) >= tonumber(needCnt) then
      wnd.itemIcon:OverlayInvisible()
    else
      wnd.itemIcon:OverlayInvisible(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    end
  end
  local EnableCheckFunc = function(wnd)
    local curCnt = X2Bag:GetCountInBag(X2Faction:GetNationOwnerChangeItem())
    local needCnt = X2Faction:GetNationOwnerChangeItemCount()
    return curCnt >= needCnt
  end
  local argTable = {
    title = GetUIText(NATION_TEXT, "delegation_owner"),
    content = GetUIText(COMMON_TEXT, "change_nation_owner_target"),
    ownerWnd = nil,
    applyNamePolicy = VNT_CHAR,
    autoTextChange = false,
    defaultInputText = "",
    guideTip = nil,
    okProc = ChangeNationOwner,
    addedFunc = AddedFunc
  }
  EditTitleFunc(argTable)
end
function ShowRenameExpedition(byItem, triedName, ownerWnd)
  if not X2Player:GetFeatureSet().renameExpeditionByItem and byItem then
    return
  end
  local function RenameExpedition(name)
    if byItem then
      local function DialogHandler(wnd)
        ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_SEPERATE_TEXT)
        wnd:SetTextColor(FONT_COLOR.DEFAULT, FONT_COLOR.RED)
        wnd:SetTextSize(FONT_SIZE.LARGE, FONT_SIZE.MIDDLE)
        local period = X2Faction:GetRenameExpeditionPeriod() or 0
        wnd:SetTitle(GetUIText(COMMON_TEXT, "rename_expedition_name"))
        wnd:SetContent(GetUIText(COMMON_TEXT, "rename_expeiditon_to_confirm", string.format("%s%s|r", FONT_COLOR_HEX.BLUE, name)), GetUIText(COMMON_TEXT, "after_rename_expeiditon_cannot_be_changed_for_30_days", tostring(period)))
        function wnd:OkProc()
          X2Faction:RenameExpedition(name, true)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
    else
      X2Faction:RenameExpedition(name, false)
    end
  end
  local function AddedFunc(wnd)
    local bg = CreateContentBackground(wnd, "TYPE10", "brown", "artwork")
    bg:SetExtent(390, 70)
    bg:AddAnchor("TOPLEFT", wnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
    local nameLabel = wnd:CreateChildWidget("label", "nameLabel", 0, false)
    nameLabel:SetExtent(100, FONT_SIZE.LARGE)
    nameLabel:SetAutoResize(true)
    nameLabel:SetText(GetUIText(COMMON_TEXT, "expedition_name"))
    nameLabel:AddAnchor("TOPLEFT", bg, MARGIN.WINDOW_SIDE / 1.5, MARGIN.WINDOW_SIDE / 1.5)
    nameLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(nameLabel, FONT_COLOR.MIDDLE_TITLE)
    local name = wnd:CreateChildWidget("label", "name", 0, true)
    name:SetExtent(100, FONT_SIZE.MIDDLE)
    name:SetAutoResize(true)
    name:AddAnchor("TOPLEFT", nameLabel, "BOTTOMLEFT", 0, 5)
    ApplyTextColor(name, FONT_COLOR.DEFAULT)
    name:SetText(X2Faction:GetFactionName(X2Faction:GetMyExpeditionId(), false))
    wnd.textbox.style:SetFontSize(FONT_SIZE.LARGE)
    wnd.textbox.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(wnd.textbox, FONT_COLOR.MIDDLE_TITLE)
    wnd.textbox:AddAnchor("TOPLEFT", name, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE)
    wnd.guide.style:SetAlign(ALIGN_LEFT)
    wnd.guide:RemoveAllAnchors()
    wnd.guide:AddAnchor("TOPLEFT", wnd.textbox, "BOTTOMLEFT", 0, 5)
    wnd.editbox:SetWidth(370)
    wnd.editbox:RemoveAllAnchors()
    wnd.editbox:AddAnchor("TOPLEFT", wnd.guide, "BOTTOMLEFT", 0, 5)
    if triedName ~= nil then
      wnd.editbox:SetText(triedName)
    end
    if byItem then
      local itemIcon = CreateItemIconButton("itemIcon", wnd)
      itemIcon:AddAnchor("TOP", wnd.editbox, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
      local itemName = wnd:CreateChildWidget("label", "itemName", 0, false)
      itemName:SetExtent(100, FONT_SIZE.MIDDLE)
      itemName:SetAutoResize(true)
      itemName:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 5)
      ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
      wnd:RegistBottomWidget(itemName)
      local itemType, hasCount, needCount = X2Faction:GetRenameExpeditionItem()
      local itemInfo = X2Item:GetItemInfoByType(itemType)
      itemIcon:SetItemInfo(itemInfo)
      itemIcon:SetStack(hasCount, needCount)
      itemName:SetText(itemInfo.name)
      if tonumber(hasCount) >= tonumber(needCount) then
        wnd.itemIcon:OverlayInvisible()
      else
        wnd.itemIcon:OverlayInvisible(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      end
    end
    wnd.btnOk:RemoveAllAnchors()
    wnd.btnCancel:RemoveAllAnchors()
    local buttonTable = {
      wnd.btnOk,
      wnd.btnCancel
    }
    ReanchorDefaultTextButtonSet(buttonTable, wnd, -MARGIN.WINDOW_SIDE)
    function wnd:Resize()
      self:SetExtent(430, self:GetFrameHeight() - 20)
    end
    function wnd:CancelProc()
      if ownerWnd ~= nil then
        ownerWnd:Show(false)
      end
    end
  end
  local function EnableCheckFunc(wnd)
    if not byItem then
      return true
    end
    local _, hasCount, needCount = X2Faction:GetRenameExpeditionItem()
    return needCount <= hasCount
  end
  local argTable = {
    title = GetUIText(COMMON_TEXT, "rename_expedition_name"),
    content = GetUIText(COMMON_TEXT, "to_rename_expedition"),
    ownerWnd = ownerWnd,
    applyNamePolicy = VNT_FACTION,
    autoTextChange = false,
    defaultInputText = "",
    guideTip = GetUIText(COMMON_TEXT, "name_guide_expedition"),
    okProc = RenameExpedition,
    addedFunc = AddedFunc,
    enableCheckFunc = EnableCheckFunc
  }
  EditTitleFunc(argTable)
end
UIParent:SetEventHandler("SHOW_RENAME_EXPEIDITON", ShowRenameExpedition)
