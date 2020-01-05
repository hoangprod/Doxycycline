local MAX_POPUP_MENU_COUNT = MAX_OVER_HEAD_MARKER + 1
local offsetX = 0
local iconInfo = {}
local targetPopup = {
  delegateJointLeader = GetCommonText("delegate_raid_joint_owner"),
  delegateJointOfficer = GetCommonText("delegate_raid_joint_officer"),
  inviteRaidTeam = GetUIText(MSG_BOX_TITLE_TEXT, "ask_raidteam_invite"),
  inviteSiegeRaidTeam = GetUIText(MSG_BOX_TITLE_TEXT, "ask_siege_raid_team_invite"),
  inviteParty = GetUIText(TARGET_POPUP_TEXT, "inviteParty"),
  requestTrade = GetUIText(TARGET_POPUP_TEXT, "requestTrade"),
  whisper = GetUIText(CHAT_CHANNEL_TEXT, "whisper"),
  requestPlayDiary = GetUIText(COMMUNITY_TEXT, "play_journal"),
  requestMessenger = GetUIText(EXPEDITION_TEXT, "send_message"),
  follow = GetUIText(TARGET_POPUP_TEXT, "follow"),
  reportBadUser = GetUIText(COMMON_TEXT, "report_bad_user"),
  reportBadWordUser = GetUIText(COMMON_TEXT, "report_badword_user")
}
local OVER_HEAD_MARKER_KEY = {
  "mark_01",
  "mark_02",
  "mark_03",
  "mark_04",
  "mark_05",
  "mark_06",
  "mark_07",
  "mark_08",
  "mark_09",
  "mark_heart",
  "mark_star",
  "mark_x"
}
iconInfo.overHeadMarker = {}
for i = 1, #OVER_HEAD_MARKER_KEY do
  iconInfo.overHeadMarker[i] = {}
  iconInfo.overHeadMarker[i].path = TEXTURE_PATH.OVERHEAD_MARK
  iconInfo.overHeadMarker[i].key = OVER_HEAD_MARKER_KEY[i]
end
local GetLootingMethod = function()
  local method, _, _, _ = X2Team:GetLootingRule()
  return method
end
local GetLootingMinDice = function()
  local _, _, minGrade, _ = X2Team:GetLootingRule()
  return minGrade
end
local GetLootingRollForBinOnPickup = function()
  local _, _, _, rollForBop = X2Team:GetLootingRule()
  return rollForBop
end
local SetLootingMethod = function(method, name)
  local _, _, minGrade, rollForBop = X2Team:GetLootingRule()
  X2Team:ChangeLootingRule(method, name, minGrade, rollForBop)
end
local NotUseDiceRule = function()
  local normalItemGrade = NORMAL_ITEM_GRADE
  local method, name, _, rollForBop = X2Team:GetLootingRule()
  X2Team:ChangeLootingRule(method, name, normalItemGrade, rollForBop)
end
local SetDiceRule = function(minGrade)
  local method, name, _, rollForBop = X2Team:GetLootingRule()
  X2Team:ChangeLootingRule(method, name, minGrade, rollForBop)
end
local SetRollForBindOnPickup = function(rollForBop)
  local method, name, minGrade, _ = X2Team:GetLootingRule()
  X2Team:ChangeLootingRule(method, name, minGrade, rollForBop)
end
local GetDiceBidRule = function()
  local rule = X2Team:GetTeamDiceBidRule()
  return rule
end
local SetDiceBidRule = function(bidRule)
  X2Team:SetTeamDiceBidRule(bidRule)
end
local GetKickMemberText = function()
  if X2Team:IsPartyTeam() == true then
    return GetUIText(CHAT_CHANNEL_TEXT, "party") .. " " .. GetUIText(COMMUNITY_TEXT, "kick")
  elseif X2Team:IsSiegeRaidTeam() then
    return locale.siegeRaid.title .. " " .. GetUIText(COMMUNITY_TEXT, "kick")
  else
    return GetUIText(CHAT_CHANNEL_TEXT, "raid") .. " " .. GetUIText(COMMUNITY_TEXT, "kick")
  end
end
local function GetOwnerChangeText()
  if X2Team:IsPartyTeam() == true then
    return GetUIText(TEAM_TEXT, "team_owner") .. " " .. GetUIText(PARTY_TEXT, "leader_popup_member_delegate")
  elseif X2Team:IsSiegeRaidTeam() == true then
    return GetUIText(COMMON_TEXT, "siege_raid_team_officer") .. " " .. GetUIText(PARTY_TEXT, "leader_popup_member_delegate")
  elseif X2Team:IsJointTeam() then
    if X2Team:IsJointLeader() then
      return targetPopup.delegateJointLeader
    else
      return targetPopup.delegateJointOfficer
    end
  else
    return GetUIText(RAID_TEXT, "raid_owner") .. " " .. GetUIText(PARTY_TEXT, "leader_popup_member_delegate")
  end
end
local IsMyPetTaret = function(target)
  return "playerpet" == string.sub(target, 1, 9)
end
local popupProc_InviteFamily = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Family:OpenJoin(arg)
end
local popupProc_ReportSpammer = function(target, arg)
  if arg == nil or arg.messageTimeStamp == nil or arg.stickTo == nil or arg.unitName == nil or arg.unitName == "" or arg.stickTo.GetMessageByTimeStamp == nil then
    return
  end
  local message, chatType = arg.stickTo:GetMessageByTimeStamp(arg.messageTimeStamp)
  if message ~= nil and message ~= "" then
    X2Chat:ReportSpammer(arg.unitName, message, chatType)
  end
end
local popupProc_KickMemberByName = function(target)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myMemberIndex) then
    X2Team:KickTeamMemberByName(target, X2Team:GetTeamRoleType())
  elseif X2Team:IsSiegeRaidTeam() and X2Team:IsTeamOfficer(myMemberIndex) then
    X2Team:KickTeamMemberByName(target, X2Team:GetTeamRoleType())
  end
end
local popupProc_KickMember = function(target)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myMemberIndex) then
    X2Team:KickTeamMember(target, X2Team:GetTeamRoleType())
  elseif X2Team:IsSiegeRaidTeam() and X2Team:IsTeamOfficer(myMemberIndex) then
    X2Team:KickTeamMember(target, X2Team:GetTeamRoleType())
  end
end
local popupProc_MakeOwner = function(target)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myMemberIndex) then
    X2Team:MakeTeamOwner(target)
  end
end
local popupProc_MakeOfficer = function(target)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myMemberIndex) then
    X2Team:MakeTeamOfficer(target)
  end
end
local popupProc_LeaveTeam = function()
  local isInTeam = X2Team:IsPartyTeam() or X2Team:IsRaidTeam()
  if isInTeam == false then
    if X2Team:IsSiegeRaidTeam() then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.siegeRaid.leaveTeamError)
    else
      X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.team.leaveTeamError)
    end
    return
  end
  X2Team:LeaveTeam(X2Team:GetTeamRoleType())
end
local function popupProc_ChangeLootRule(target, arg)
  local name = X2Unit:UnitName(target)
  SetLootingMethod(arg, name)
end
local popupProc_ChangeRole = function(target, arg)
  X2Team:SetRole(arg)
end
local popupProc_RequestTrade = function()
  X2Trade:RequestTrade()
end
local popupProc_Whisper = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Chat:ActivateWhisperChatInput(arg)
end
local popupProc_InviteTeam = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Team:InviteToTeam(arg, true)
end
local popupProc_InviteRaid = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Team:InviteToTeam(arg, false)
end
local popupProc_InviteRaidJoint = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Team:JointInfoReq(TEAM_JOINT_REQUEST, arg)
end
local popupProc_InviteSquad = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Squad:InviteSquad(arg)
end
local popupProc_ExpelSquad = function(target, arg)
  X2Squad:ExpelSquad(X2Unit:GetUnitId(target))
end
local popupProc_DelegateSquad = function(target, arg)
  X2Squad:DelegateSquadLeader(X2Unit:GetUnitId(target))
end
local popupProc_LeaveSquad = function(target, arg)
  if not X2Squad:HasMySquad() then
    return
  end
  X2Squad:LeaveSquad()
end
local popupProc_MemberExpelSquad = function(_, arg)
  X2Squad:ExpelSquadByCId(arg)
end
local popupProc_MemberDelegateSquad = function(_, arg)
  X2Squad:DelegateSquadLeaderByCId(arg)
end
local popupProc_InviteExpedition = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  if X2Faction:GetMyExpeditionId() ~= nil and not X2Faction:IsMyExpeditionMember(arg) then
    X2Faction:InviteToExpedition(arg)
  end
end
local popupProc_AddFriend = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  if not X2Friend:IsMyFriend(arg) then
    X2Friend:AddFriend(arg)
  end
end
local popupProc_DeleteFriend = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  if X2Friend:IsMyFriend(arg) then
    X2Friend:DeleteFriend(arg)
  end
end
local popupProc_WebPlayDairy = function(target, arg)
  if arg == nil then
    OnToggleWebDiary(true, "target_unit")
  else
    OnToggleWebDiary(true, arg)
  end
end
local popupProc_WebMessenger = function(target, arg)
  if arg == nil then
    OnToggleWebMessenger(true, "target_unit")
  else
    OnToggleWebMessenger(true, arg)
  end
end
local popupProc_SetBountyMoney = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Trial:RequestSetBountyMoney(arg)
end
local function popupProc_SetLootOfficer(target)
  local isJointTeam = X2Team:IsJointTeam()
  if not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
    local name = X2Unit:UnitName(target)
    if name ~= nil and name ~= "" then
      SetLootingMethod(TEAM_LOOT_MASTER_LOOTER, name)
    end
  end
end
local popupProc_AddIgnore = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Friend:BlockUser(arg)
end
local popupProc_UnBlock = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Friend:UnblockUser(arg)
end
local popupProc_ChallengeTargetToDuel = function()
  X2Unit:ChallengeTargetToDuel()
end
local popupProc_SetOverheadMarker = function(target, arg)
  X2Unit:SetOverHeadMarker(target, arg)
end
local popupProc_RemoveAllOverheadMarker = function()
  X2Unit:RemoveAllOverHeadMarker()
end
local popupProc_Follow = function()
  X2Unit:Follow("target")
end
local popupProc_KickFromExpedition = function(_, arg)
  local function KickExpeditioinMember(wnd, infoTable)
    local name = arg
    wnd:SetTitle(GetUIText(EXPEDITION_TEXT, "expel"))
    wnd:UpdateDialogModule("textbox", GetCommonText("kick_expd_member_name", name))
    function wnd:OkProc()
      X2Faction:KickFromExpedition(name)
    end
  end
  X2DialogManager:RequestDefaultDialog(KickExpeditioinMember, "")
end
local popupProc_ChangeExpeditionRole = function(_, arg)
  X2Faction:ChangeExpeditionMemberRole(arg.name, arg.index)
end
local popupProc_ChangeFamilyOwner = function(_, arg)
  X2Family:ChangeOwner(arg)
end
local popupProc_KickFamily = function(target, arg)
  X2Family:OpenKick(arg)
end
local popupProc_LeaveFamily = function()
  X2Family:OpenLeave()
end
local popupProc_ChangeFamilyRole = function(_, arg)
  X2Family:ChangeMemberRole(arg.name, arg.role)
end
local function popupProc_ActivateLootRulePopupMenu(target, arg, stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  for i = 1, #locale.party.lootRule.popups do
    popupInfo:AddInfo(locale.party.lootRule.popups[i], popupProc_ChangeLootRule, i - 1)
    popupInfo:AddRadioBtn(i == arg)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", 0, 0)
end
local function popupProc_NotUseDiceRule(_, arg)
  NotUseDiceRule()
end
local function popupProc_UseDiceRule(_, arg)
  SetDiceRule(arg)
end
local IsAllowedGrade = function(grade)
  local UNCOMMON_GRADE = 2
  local UNIQUE_GRADE = 6
  if grade >= UNCOMMON_GRADE and grade <= UNIQUE_GRADE then
    return true
  else
    return false
  end
end
local function popupProc_ActivateDiceRulePopupMenu(target, arg, stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  popupInfo:AddInfo(locale.lootPopupText.notUseDiceRule, popupProc_NotUseDiceRule)
  popupInfo:AddRadioBtn(arg == NORMAL_ITEM_GRADE)
  local grades = X2Item:AllGradeTypes()
  for i = 1, #grades do
    local grade = grades[i]
    if IsAllowedGrade(grade) then
      local gradeText = locale.lootPopupText.GetMoreThenGrade(X2Item:GradeName(grade))
      popupInfo:AddInfo(gradeText, popupProc_UseDiceRule, grade)
      popupInfo:AddTextButtonColor(X2Item:GradeColor(grade))
      popupInfo:AddRadioBtn(grade == arg)
    end
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", 0, 0)
end
local function popupProc_NotUseBindOnPickupRule(_, arg)
  SetRollForBindOnPickup(false)
end
local function popupProc_UseBindOnPickupRule()
  SetRollForBindOnPickup(true)
end
local function popupProc_UseDiceBidRule(_, arg)
  SetDiceBidRule(arg)
end
local function popupProc_ActivateBindOnAcqRule(target, arg, stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  useBindOnPickup = arg
  popupInfo:AddInfo(locale.lootPopupText.notUseDiceRule, popupProc_NotUseBindOnPickupRule)
  popupInfo:AddRadioBtn(not useBindOnPickup)
  popupInfo:AddInfo(locale.lootPopupText.useBindOnPickup_Dice, popupProc_UseBindOnPickupRule)
  popupInfo:AddRadioBtn(useBindOnPickup)
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", 0, 0)
end
local function popupProc_ActivateOverHeadMarkerPopupMenu(target, arg, stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  local targetId = X2Unit:GetUnitId(target)
  for i = 1, MAX_POPUP_MENU_COUNT do
    local markerUnitId = X2Unit:GetOverHeadMarkerUnitId(i)
    if i == MAX_POPUP_MENU_COUNT then
      popupInfo:AddInfo(locale.unitFrame.removeAll, popupProc_RemoveAllOverheadMarker)
    else
      popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_SetOverheadMarker, i)
      popupInfo:AddCheckBtn(markerUnitId ~= nil, markerUnitId == targetId)
      popupInfo:AddImage(iconInfo.overHeadMarker[i])
    end
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", componentsLocale.popupMenu.offsetX, 15)
end
local function popupProc_ActivateFamilyRolePopupMenu(target, name, stickTo)
  if name == nil then
    return
  end
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  local roleList = X2Family:GetRoleList()
  for i = 1, #roleList do
    local role = roleList[i]
    local arg = {}
    arg.name = name
    arg.role = i
    local remainRoleCount = GetCommonText("not_selected")
    if role.remainRoleCount > 0 then
      remainRoleCount = tostring(role.remainRoleCount)
    end
    local str = string.format("%s(%s)", role.name, remainRoleCount)
    popupInfo:AddInfo(str, popupProc_ChangeFamilyRole, arg)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", componentsLocale.popupMenu.offsetX, 0)
end
local popupProc_AddWatchTarget = function(_, unitId)
  X2Unit:SetWatchTarget(unitId)
end
local popupProc_BanVoteTarget = function(_, unitId)
  X2Unit:BanVoteTarget(unitId, BANVOTE_TYPE_CHECK_ENABLE, BRT_NO_REASON)
end
local popupProc_ReleaseWatchTarget = function()
  X2Unit:ReleaseWatchTarget()
end
local function popupProc_ActivateBidRule(target, arg, stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  for i = 1, #locale.diceBidRule.popups do
    popupInfo:AddInfo(locale.diceBidRule.popups[i], popupProc_UseDiceBidRule, i)
    popupInfo:AddRadioBtn(i == arg)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", 0, 0)
end
local function MakeTeamRolePopupMenu(popupInfo, role)
  local text_inset = {}
  text_inset.left = 18
  text_inset.right = 0
  local roleInfo = W_MODULE:GetRoleInfo()
  for i, v in ipairs(roleInfo) do
    popupInfo:AddInfo(v.text, popupProc_ChangeRole, v.value)
    popupInfo:AddRadioBtn(role == v.value)
    if v.image ~= nil then
      local anchorInfo = {}
      anchorInfo.myAnchor = "LEFT"
      anchorInfo.targetAnchor = "LEFT"
      anchorInfo.anchorX = 17
      anchorInfo.anchorY = 0
      popupInfo:AddImageAnchorInfo(anchorInfo)
      local imageInfo = {
        path = v.image.path,
        key = v.image.key
      }
      popupInfo:AddImage(imageInfo)
      popupInfo:AddLayoutInfo(text_inset)
    end
    popupInfo:AddTextButtonColor(v.fontColor)
  end
end
local function popupProc_ActivateTeamRolePopupMenu(target, arg, stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  local myIndex = X2Team:GetTeamPlayerIndex()
  local role = X2Team:GetRole(X2Team:GetMyTeamJointOrder(), myIndex)
  MakeTeamRolePopupMenu(popupInfo, role)
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, true, "TOPLEFT", "TOPRIGHT", 0, 0)
end
local popupProc_ShowTargetEquipment = function()
  ShowTargetEquipment()
end
local popupProc_ToggleForceAttack = function()
  X2Player:AskToggleForceAttack()
end
local popupProc_ReportBadUser = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Trial:StartReportBadUserUI(arg)
end
local popupProc_ReportBadWordUser = function(target, arg)
  if arg == nil then
    arg = X2Unit:UnitName(target)
  end
  X2Trial:ReportBadWordUser(arg)
end
local popupProc_RequestRankerEquipItemInfo = function(_, popupData)
  X2Rank:RequestRankerAppearance(popupData.worldID, popupData.charID, popupData.charName)
end
local function AddLootingRulePopupMenu(popupInfo, teamOwner, targetPopup)
  local hasChild = teamOwner
  local disableMenu = teamOwner == false
  local lootingMethod = GetLootingMethod() + 1
  local title = locale.lootPopupText.GetDoubleTitle(locale.party.leaderPopupLeaders[2], locale.party.lootRule.popups[lootingMethod])
  popupInfo:AddInfo(title, popupProc_ActivateLootRulePopupMenu, lootingMethod, hasChild)
  if disableMenu then
    popupInfo:AddDisableStatus(true)
  end
  local minGrade = GetLootingMinDice()
  if minGrade == NORMAL_ITEM_GRADE then
    title = locale.lootPopupText.GetDoubleTitle(locale.lootPopupText.diceDistribute, locale.lootPopupText.notUseDiceRule)
  else
    title = locale.lootPopupText.GetDoubleTitle(locale.lootPopupText.diceDistribute, locale.lootPopupText.GetMoreThenGrade(X2Item:GradeName(minGrade)))
  end
  popupInfo:AddInfo(title, popupProc_ActivateDiceRulePopupMenu, minGrade, hasChild)
  if disableMenu then
    popupInfo:AddDisableStatus(true)
  end
  local useBindOnPickup = GetLootingRollForBinOnPickup()
  if useBindOnPickup then
    title = locale.lootPopupText.GetDoubleTitle(locale.lootPopupText.bindOnPickup, locale.lootPopupText.useBindOnPickup_Dice)
  else
    title = locale.lootPopupText.GetDoubleTitle(locale.lootPopupText.bindOnPickup, locale.lootPopupText.notUseBindOnPickup)
  end
  popupInfo:AddInfo(title, popupProc_ActivateBindOnAcqRule, useBindOnPickup, hasChild)
  if disableMenu then
    popupInfo:AddDisableStatus(true)
  end
  local isJointTeam = X2Team:IsJointTeam()
  if not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
    popupInfo:AddInfo(locale.team.setlootingOfficer, popupProc_SetLootOfficer)
    if disableMenu then
      popupInfo:AddDisableStatus(true)
    end
  end
  if targetPopup == false then
    local diceBidRule = GetDiceBidRule()
    title = locale.lootPopupText.GetDoubleTitle(locale.diceBidRule.popupTitle, locale.diceBidRule.popups[diceBidRule])
    popupInfo:AddInfo(title, popupProc_ActivateBidRule, diceBidRule, true)
  end
end
local function AddWatchTargetMenu(popupInfo, selectUnitId)
  local watchTargetUnitId = X2Unit:GetUnitId("watchtarget")
  if watchTargetUnitId and watchTargetUnitId == selectUnitId then
    popupInfo:AddInfo(GetUIText(UNIT_FRAME_TEXT, "watch_target_release"), popupProc_ReleaseWatchTarget)
  else
    popupInfo:AddInfo(GetUIText(UNIT_FRAME_TEXT, "watch_target_set"), popupProc_AddWatchTarget, selectUnitId)
  end
end
local function AddBanVoteTargetMenu(popupInfo, selectUnitId)
  popupInfo:AddInfo(GetCommonText("ban_vote"), popupProc_BanVoteTarget, selectUnitId)
end
local function AddShowTargetEquipInfoMenu(popupInfo)
  if X2Player:GetFeatureSet().targetEquipmentWnd then
    if X2Unit:IsMe("target") == true then
      return
    end
    local isShowable = X2Unit:ShowableEquipInfo(popupInfo.target)
    if isShowable == true then
      popupInfo:AddInfo(GetCommonText("show_target_equipment"), popupProc_ShowTargetEquipment)
    elseif isShowable == false then
      popupInfo:AddInfo(GetCommonText("close_target_equipment"), popupProc_ShowTargetEquipment)
      popupInfo:AddDisableStatus(true)
    end
  end
end
local AddExpeditionWarMenu = function(popupInfo)
  local popupProc_DeclareExpeditionWar = function()
    X2Faction:RequestDeclarationMoney()
  end
  if X2Faction:CanDeclareExpeditionWar() ~= true then
    return
  end
  popupInfo:AddInfo(GetCommonText("declare_expedition_war"), popupProc_DeclareExpeditionWar)
end
local function AddForceAttackMenu(popupInfo)
  local bindKeyText = string.upper(X2Hotkey:GetBinding("toggle_force_attack", 1))
  local tooltipText = locale.forceAttack.toolTip(X2Player:GetFeatureSet().protectPvp)
  if bindKeyText ~= "" then
    tooltipText = string.format([[
%s%s
|r%s]], FONT_COLOR_HEX.POPUP_MENU_BINDING_KEY, bindKeyText, tooltipText)
  end
  local tooltipData = {
    text = tooltipText,
    myAnchor = "TOPLEFT",
    targetAnchor = "BOTTOMRIGHT",
    offsetX = -20,
    offsetY = 0
  }
  local menuText
  if X2Unit:UnitIsForceAttack(popupInfo.target) then
    menuText = GetUIText(PLAYER_POPUP_TEXT, "force_attack_off")
  else
    menuText = GetUIText(PLAYER_POPUP_TEXT, "force_attack_on")
  end
  popupInfo:AddInfo(menuText, popupProc_ToggleForceAttack, nil, false, tooltipData)
end
local function AddFollowMenu(popupInfo)
  if not UIParent:GetPermission(UIC_FOLLOW) then
    return
  end
  popupInfo:AddInfo(targetPopup.follow, popupProc_Follow)
  if X2Player:GetFeatureSet().restrictFollow and X2Player:IsBoundSlave() then
    popupInfo:AddDisableStatus(true)
  end
end
local function PlayerPopup(stickTo)
  local popupInfo = GetDefaultPopupInfoTable()
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  local isPartyTeam = X2Team:IsPartyTeam()
  local isRaidTeam = X2Team:IsRaidTeam()
  local isInTeam = isPartyTeam or isRaidTeam
  local isOwner = X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myMemberIndex)
  local isJointTeam = X2Team:IsJointTeam()
  local isTeamJointLeader = X2Team:IsJointLeader()
  local isSiegeRaidTeam = X2Team:IsSiegeRaidTeam()
  popupInfo.target = "player"
  if isSiegeRaidTeam == false then
    if isOwner and (not isJointTeam or isJointTeam and isTeamJointLeader) then
      AddLootingRulePopupMenu(popupInfo, true, false)
    elseif isInTeam then
      AddLootingRulePopupMenu(popupInfo, false, false)
    end
  end
  if isInTeam then
    if isRaidTeam then
      popupInfo:AddInfo(locale.raid.setMyRole, popupProc_ActivateTeamRolePopupMenu, nil, true)
    end
    if isSiegeRaidTeam == false and UIParent:GetPermission(UIC_PARTY) and X2Team:IsPossibleLeaveTeam() then
      popupInfo:AddInfo(locale.team.leave(), popupProc_LeaveTeam)
    end
  end
  if X2Player:GetFeatureSet().squad and UIParent:GetPermission(UIC_SQUAD) and X2Squad:HasMySquad() then
    popupInfo:AddInfo(locale.squad.leave, popupProc_LeaveSquad)
  end
  if isSiegeRaidTeam == false or X2Player:GetFeatureSet().useForceAttack then
    AddForceAttackMenu(popupInfo)
  end
  if isOwner and (not isJointTeam or isJointTeam and isTeamJointLeader) then
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
local function BaseTeamPopup(popupInfo, data)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  local myJointOrder = X2Team:GetMyTeamJointOrder()
  local isOwner = X2Team:IsTeamOwner(myJointOrder, myMemberIndex)
  local isJointTeam = X2Team:IsJointTeam()
  local isTeamJointLeader = X2Team:IsJointLeader()
  popupInfo.target = "team" .. data.memberIndex
  if isOwner then
    if not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
      popupInfo:AddInfo(locale.team.setlootingOfficer, popupProc_SetLootOfficer)
    end
    if myMemberIndex ~= data.memberIndex then
      if X2Team:IsPossibleLeaveTeam() then
        popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
      end
      if X2Unit:UnitIsOffline(popupInfo.target) == false and (not isJointTeam or isJointTeam and not isTeamJointLeader) then
        popupInfo:AddInfo(GetOwnerChangeText(), popupProc_MakeOwner)
      end
    end
  elseif myMemberIndex == data.memberIndex and X2Team:IsPossibleLeaveTeam() then
    popupInfo:AddInfo(locale.team.leave(), popupProc_LeaveTeam)
  end
  if X2Player:GetFeatureSet().squad and UIParent:GetPermission(UIC_SQUAD) and X2Squad:IsLeader() then
    popupInfo:AddInfo(locale.squad.invite, popupProc_InviteSquad, X2Unit:UnitName(popupInfo.target))
  end
  if not X2Team:IsRaidTeam() or X2Team:IsMyTeamOwner(myMemberIndex) and (not isJointTeam or isJointTeam and isTeamJointLeader) then
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
end
local function SiegeRaidTeamPopup(popupInfo, data)
  if data == nil then
    return
  end
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  local myJointOrder = X2Team:GetMyTeamJointOrder()
  local isOwner = X2Team:IsTeamOwner(myJointOrder, myMemberIndex)
  local isOfficer = X2Team:IsTeamOfficer(myMemberIndex)
  local isTargetOwner = X2Team:IsTeamOwner(data.jointOrder, data.memberIndex)
  local isTargetOfficer = X2Team:IsTeamOfficer(data.memberIndex)
  popupInfo.target = "team" .. data.memberIndex
  if isOwner and not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
    popupInfo:AddInfo(locale.team.setlootingOfficer, popupProc_SetLootOfficer)
  end
  if myMemberIndex ~= data.memberIndex then
    if X2Team:IsPossibleLeaveTeam() then
      if isOwner == true then
        popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
      elseif isOfficer == true and isTargetOwner == false and isTargetOfficer == false then
        popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
      end
    end
    if isOwner == true and isTargetOfficer == false then
      popupInfo:AddInfo(GetOwnerChangeText(), popupProc_MakeOfficer)
    end
  end
  if isOwner then
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
end
local function TeamPopup(stickTo, data)
  local popupInfo = GetDefaultPopupInfoTable()
  if X2Team:IsSiegeRaidTeam() then
    SiegeRaidTeamPopup(popupInfo, data)
  else
    BaseTeamPopup(popupInfo, data)
  end
  AddFollowMenu(popupInfo)
  local targetId = X2Unit:GetUnitId(popupInfo.target)
  AddWatchTargetMenu(popupInfo, targetId)
  if X2Player:IsInSeamlessZone() == false then
    AddBanVoteTargetMenu(popupInfo, targetId)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
local function JointTeamPopup(stickTo, data)
  local popupInfo = GetDefaultPopupInfoTable()
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  local myJointOrder = X2Team:GetMyTeamJointOrder()
  local isOwner = X2Team:IsTeamOwner(myJointOrder, myMemberIndex)
  local isTeamJointLeader = X2Team:IsJointLeader()
  popupInfo.target = "team_" .. tostring(data.jointOrder) .. "_" .. tostring(data.memberIndex)
  if isTeamJointLeader and isOwner then
    local targetAuthority = X2Unit:UnitTeamAuthority(popupInfo.target)
    if targetAuthority == "jointsubleader" then
      popupInfo:AddInfo(targetPopup.delegateJointLeader, popupProc_MakeOwner, nil)
    end
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
  AddFollowMenu(popupInfo)
  local targetId = X2Unit:GetUnitId(popupInfo.target)
  AddWatchTargetMenu(popupInfo, targetId)
  if X2Player:IsInSeamlessZone() == false then
    AddBanVoteTargetMenu(popupInfo, targetId)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
local GetNewReportBadUser = function()
  local featureSet = X2Player:GetFeatureSet()
  if not featureSet.newReportBaduser then
    return false
  else
    return true
  end
end
local GetReportBadWordUser = function()
  local featureSet = X2Player:GetFeatureSet()
  if not featureSet.reportBadWordUser then
    return false
  else
    return true
  end
end
local CanInviteExpedition = function()
  if X2Faction:GetMyExpeditionId() ~= 0 then
    local policy = GetRolePolicy("my")
    return policy[GetRolePolicyList().INVITE]
  end
  return false
end
local function MenuRequestTrade(popupInfo, data)
  if not UIParent:GetPermission(UIC_TRADE) then
    return
  end
  popupInfo:AddInfo(targetPopup.requestTrade, popupProc_RequestTrade)
end
local function MenuSquad(popupInfo, data)
  if not X2Player:GetFeatureSet().squad or not UIParent:GetPermission(UIC_SQUAD) or not X2Squad:HasMySquad() then
    return
  end
  if X2Squad:IsLeader() then
    if X2Squad:IsSameSquad(X2Unit:GetUnitId(popupInfo.target)) then
      popupInfo:AddInfo(locale.squad.expel, popupProc_ExpelSquad)
      popupInfo:AddInfo(locale.squad.delegate, popupProc_DelegateSquad)
    else
      popupInfo:AddInfo(locale.squad.invite, popupProc_InviteSquad)
    end
  end
end
local function MenuSquadInviteOnly(popupInfo, data)
  if not X2Player:GetFeatureSet().squad or not UIParent:GetPermission(UIC_SQUAD) or not X2Squad:HasMySquad() then
    return
  end
  if not X2Squad:IsLeader() then
    return
  end
  popupInfo:AddInfo(locale.squad.invite, popupProc_InviteSquad, data.name)
end
local function MenuFamily(popupInfo, data)
  if not UIParent:GetPermission(UIC_FAMILY) then
    return
  end
  if X2Family:IsFamily() == false then
    popupInfo:AddInfo(locale.family.add_family, popupProc_InviteFamily, data.name)
  elseif X2Family:IsOwner() and X2Family:IsMyFamily(data.name) == false then
    popupInfo:AddInfo(locale.family.add_family, popupProc_InviteFamily, data.name)
  end
end
local function MenuExpedition(popupInfo, data)
  if not UIParent:GetPermission(UIC_EXPEDITION) then
    return
  end
  if X2Faction:IsExpedInfoLoaded() == true and X2Faction:GetMyExpeditionId() ~= 0 and X2Faction:IsMyExpeditionMember(data.name) == false and CanInviteExpedition() then
    popupInfo:AddInfo(locale.expedition.invite, popupProc_InviteExpedition)
  end
end
local function MenuFriend(popupInfo, data)
  if not UIParent:GetPermission(UIC_FRIEND) then
    return
  end
  if X2Friend:IsMyFriend(data.name) == false then
    popupInfo:AddInfo(locale.friend.addFriend, popupProc_AddFriend, data.name)
  else
    popupInfo:AddInfo(locale.friend.deleteFriend, popupProc_DeleteFriend, data.name)
  end
end
local function MenuBlockedUser(popupInfo, data)
  if not UIParent:GetPermission(UIC_FRIEND) then
    return
  end
  if X2Friend:IsBlockedUser(data.name) then
    popupInfo:AddInfo(locale.community.unblock, popupProc_UnBlock, data.name)
  else
    popupInfo:AddInfo(locale.block.add, popupProc_AddIgnore, data.name)
  end
end
local function MenuChallenge(popupInfo, data)
  if UIParent:GetPermission(UIC_CHALLENGE) then
    popupInfo:AddInfo(locale.duel.challenge, popupProc_ChallengeTargetToDuel)
  end
end
local function MenuPlayDiary(popupInfo, data)
  if not UIParent:GetPermission(UIC_WEB_PLAY_DIARY) then
    return
  end
  if baselibLocale.useWebDiary then
    popupInfo:AddInfo(targetPopup.requestPlayDiary, popupProc_WebPlayDairy)
  end
end
local function MenuMessage(popupInfo, data)
  if not UIParent:GetPermission(UIC_WEB_MESSENGER) then
    return
  end
  if baselibLocale.useWebMessenger then
    popupInfo:AddInfo(targetPopup.requestMessenger, popupProc_WebMessenger, data.name)
  end
end
local function MenuWhisper(popupInfo, data)
  if not UIParent:GetPermission(UIC_WHISPER) then
    return
  end
  popupInfo:AddInfo(targetPopup.whisper, popupProc_Whisper, data.name)
end
local function MenuFollow(popupInfo, data)
  local order, index = X2Team:GetMemberIndex("target")
  if order ~= nil then
    AddFollowMenu(popupInfo)
  end
end
local function MenuExpeditionWar(popupInfo, data)
  if not UIParent:GetPermission(UIC_EXPEDITION) then
    return
  end
  if data.unitType == "player" or data.unitType == "character" then
    AddExpeditionWarMenu(popupInfo)
  end
end
local function MenuTargetEquipInfo(popupInfo, data)
  AddShowTargetEquipInfoMenu(popupInfo)
end
local function MenuReportBadUser(popupInfo, data)
  if not UIParent:GetPermission(UIC_REPORT_BAD_USER) then
    return
  end
  if data.unitType == "character" and GetNewReportBadUser() == true and (relationship ~= 1 and baselibLocale.useEnemyReportPopup == false or baselibLocale.useEnemyReportPopup == true) then
    popupInfo:AddInfo(targetPopup.reportBadUser, popupProc_ReportBadUser)
  end
end
local function MenuWatchTarget(popupInfo, data)
  targetId = X2Unit:GetUnitId("target")
  AddWatchTargetMenu(popupInfo, targetId)
end
local function MenuOverHeadMarker(popupInfo, data)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  local isJointTeam = X2Team:IsJointTeam()
  local isTeamJointLeader = X2Team:IsJointLeader()
  if not X2Team:IsRaidTeam() or X2Team:IsMyTeamOwner(myMemberIndex) and (not isJointTeam or isJointTeam and isTeamJointLeader) then
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
end
local MenuSlaveChangeName = function(popupInfo, data)
  if data.target == "slave" and X2SiegeWeapon:IsTargetMySiegeWeapon() then
    popupInfo:AddInfo(locale.common.changeName, ShowChangeSlaveName, stickTo)
  end
end
local function MenuPlayDairy(popupInfo, data)
  if not UIParent:GetPermission(UIC_WEB_PLAY_DIARY) then
    return
  end
  if baselibLocale.useWebDiary then
    popupInfo:AddInfo(locale.friend.playJournal, popupProc_WebPlayDairy, data.name)
  end
end
local function MenuForceAttack(popupInfo, data)
  if X2Team:IsSiegeRaidTeam() == false or X2Player:GetFeatureSet().useForceAttack then
    AddForceAttackMenu(popupInfo)
  end
end
local function MenuSiegeRaid(popupInfo, data)
  if X2Team:IsSiegeRaidTeam() == false then
    return false
  end
  local order, index = X2Team:GetMemberIndex("target")
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  local myJointOrder = X2Team:GetMyTeamJointOrder()
  local isTeamOwner = X2Team:IsTeamOwner(myJointOrder, myMemberIndex)
  local isTeamOfficer = X2Team:IsTeamOfficer(myMemberIndex)
  if order ~= nil then
    local isJointTeam = X2Team:IsJointTeam()
    local isTargetOwner = X2Team:IsTeamOwner(order, index)
    local isTargetOfficer = X2Team:IsTeamOfficer(index)
    if isTeamOwner then
      if UIParent:GetPermission(UIC_RAID) and X2Team:IsPossibleLeaveTeam() then
        popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
      end
      if isTargetOfficer == false then
        popupInfo:AddInfo(GetOwnerChangeText(), popupProc_MakeOfficer)
      end
      if not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
        popupInfo:AddInfo(locale.team.setlootingOfficer, popupProc_SetLootOfficer)
      end
    elseif isTeamOfficer then
      if isTargetOwner == false and UIParent:GetPermission(UIC_RAID) and X2Team:IsPossibleLeaveTeam() then
        popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
      end
      if not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
        popupInfo:AddInfo(locale.team.setlootingOfficer, popupProc_SetLootOfficer)
      end
    end
  elseif (isTeamOwner or isTeamOfficer) and UIParent:GetPermission(UIC_RAID) then
    popupInfo:AddInfo(targetPopup.inviteSiegeRaidTeam, popupProc_InviteRaid)
  end
  return true
end
local IsTeam = function()
  if X2Team:IsPartyTeam() or X2Team:IsRaidTeam() then
    return true
  end
  return false
end
local function TargetPopup(stickTo, target, data)
  local popupInfo = GetDefaultPopupInfoTable()
  local unitType = F_UNIT.GetUnitType("target")
  local targetUnitName = X2Unit:UnitName("target")
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  popupInfo.target = "target"
  local relationship = X2:GetTargetFactionRelationship()
  local function MenuParty(popupInfo, data)
    if MenuSiegeRaid(popupInfo, data) then
      return
    end
    local order, index = X2Team:GetMemberIndex("target")
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if order ~= nil then
      if X2Team:IsTeamOwner(myJointOrder, X2Team:GetTeamPlayerIndex()) then
        if X2Team:IsJointTeam() then
          if order == myJointOrder then
            if UIParent:GetPermission(UIC_PARTY) and X2Team:IsPossibleLeaveTeam() then
              popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
            end
            if not X2Team:IsJointLeader() then
              popupInfo:AddInfo(GetOwnerChangeText(), popupProc_MakeOwner)
            end
          elseif X2Team:IsJointLeader() and X2Team:IsTeamOwner(order, index) then
            popupInfo:AddInfo(GetOwnerChangeText(), popupProc_MakeOwner)
          end
        else
          if UIParent:GetPermission(UIC_PARTY) and X2Team:IsPossibleLeaveTeam() then
            popupInfo:AddInfo(GetKickMemberText(), popupProc_KickMember)
          end
          popupInfo:AddInfo(GetOwnerChangeText(), popupProc_MakeOwner)
          local isJointTeam = X2Team:IsJointTeam()
          if not isJointTeam and GetLootingMethod() == TEAM_LOOT_MASTER_LOOTER then
            popupInfo:AddInfo(locale.team.setlootingOfficer, popupProc_SetLootOfficer)
          end
        end
      end
    else
      if UIParent:GetPermission(UIC_PARTY) and (X2Team:IsPartyTeam() and X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) or IsTeam() == false) then
        popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam)
      end
      if UIParent:GetPermission(UIC_RAID) and (X2Team:IsRaidTeam() and X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) or IsTeam() == false) then
        popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid)
      end
      if data.jointable then
        popupInfo:AddInfo(GetCommonText("raid_joint_req_title"), popupProc_InviteRaidJoint)
      end
    end
  end
  local targetPopupMenuList = {
    [UR_FRIENDLY] = {
      MenuRequestTrade,
      MenuParty,
      MenuSquad,
      MenuFamily,
      MenuExpedition,
      MenuFriend,
      MenuBlockedUser,
      MenuChallenge,
      MenuExpeditionWar,
      MenuFollow,
      MenuWatchTarget,
      MenuOverHeadMarker,
      MenuWhisper,
      MenuPlayDiary,
      MenuMessage,
      MenuTargetEquipInfo,
      MenuReportBadUser
    },
    [UR_NEUTRAL] = {
      MenuSquad,
      MenuFamily,
      MenuFriend,
      MenuBlockedUser,
      MenuChallenge,
      MenuExpeditionWar,
      MenuWatchTarget,
      MenuOverHeadMarker,
      MenuWhisper,
      MenuPlayDiary,
      MenuMessage,
      MenuTargetEquipInfo,
      MenuReportBadUser
    },
    [UR_HOSTILE] = {
      MenuTargetEquipInfo,
      MenuSquad,
      MenuExpeditionWar,
      MenuReportBadUser,
      MenuWatchTarget,
      MenuOverHeadMarker
    }
  }
  local siegeTargetPopupMenuList = {
    [UR_FRIENDLY] = {
      MenuRequestTrade,
      MenuParty,
      MenuFollow,
      MenuWhisper,
      MenuTargetEquipInfo,
      MenuWatchTarget,
      MenuOverHeadMarker
    },
    [UR_NEUTRAL] = {
      MenuWhisper,
      MenuTargetEquipInfo,
      MenuWatchTarget,
      MenuOverHeadMarker
    },
    [UR_HOSTILE] = {
      MenuTargetEquipInfo,
      MenuWatchTarget,
      MenuOverHeadMarker
    }
  }
  local myPopupMenuList = {
    normal = {MenuForceAttack, MenuOverHeadMarker},
    siege = {MenuOverHeadMarker}
  }
  local targetPopupMenuData = {unitType = unitType, name = targetUnitName}
  if data ~= nil then
    targetPopupMenuData.jointable = data.jointable
  end
  local function CreateMenuList()
    if unitType ~= "player" and unitType ~= "character" then
      return targetPopupMenuList[UR_HOSTILE]
    end
    if X2Team:IsSiegeRaidTeam() == true and X2Dominion:GetSiegePeriodName() == "siege_period_siege" then
      if X2Unit:IsMe("target") == true then
        return myPopupMenuList.siege
      end
      return siegeTargetPopupMenuList[relationship]
    else
      if X2Unit:IsMe("target") == true then
        return myPopupMenuList.normal
      end
      return targetPopupMenuList[relationship]
    end
  end
  local menuList = CreateMenuList()
  for i = 1, #menuList do
    menuList[i](popupInfo, targetPopupMenuData)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
local function SlavePopup(stickTo, target)
  local popupInfo = GetDefaultPopupInfoTable()
  local unitId
  popupInfo.target = "target"
  local SalvePopupMenuList = {
    MenuWatchTarget,
    MenuOverHeadMarker,
    MenuSlaveChangeName
  }
  local SlavePopupMenuData = {target = target}
  for i = 1, #SalvePopupMenuList do
    SalvePopupMenuList[i](popupInfo, SlavePopupMenuData)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
local function MatePopup(stickTo, target)
  local popupInfo = GetDefaultPopupInfoTable()
  local unitId
  if target == "mate" then
    popupInfo.target = "target"
    unitId = X2Unit:GetUnitId("target")
  elseif IsMyPetTaret(target) then
    popupInfo.target = target
    unitId = X2Unit:GetUnitId(target)
  end
  AddWatchTargetMenu(popupInfo, unitId)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  if not X2Team:IsRaidTeam() or X2Team:IsMyTeamOwner(myMemberIndex) then
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
  if IsMyPetTaret(target) then
    popupInfo:AddInfo(locale.common.changeName, ShowChangeMateName, stickTo)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
local function UnitPopup(stickTo, target, data)
  local function MakeConditions(unitName)
    local conditions = {
      self = {
        isTeamOwner = X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()),
        isInTeam = X2Team:IsPartyTeam() or X2Team:IsRaidTeam(),
        isPartyTeam = X2Team:IsPartyTeam(),
        isRaidTeam = X2Team:IsRaidTeam(),
        canInviteExped = X2Faction:IsExpedInfoLoaded() and X2Faction:CanInviteExpedition(),
        isTeamJointLeader = X2Team:IsJointLeader(),
        isSquadOwner = X2Squad:IsLeader()
      },
      target = {
        isMyTeam = X2Team:GetMemberIndexByName(unitName, true) ~= nil,
        isMyJointTeam = X2Team:GetMemberIndexByName(unitName, false) ~= nil,
        isMyFriend = X2Friend:IsMyFriend(unitName),
        isMyExpedMember = X2Faction:IsExpedInfoLoaded() and X2Faction:GetMyExpeditionId() ~= 0 and X2Faction:IsMyExpeditionMember(unitName),
        isBlocked = X2Friend:IsBlockedUser(unitName),
        isJointTeamOwner = data.jointOrder ~= nil and data.jointOrder ~= X2Team:GetMyTeamJointOrder() and X2Team:IsTeamOwner(data.jointOrder, data.memberIndex)
      }
    }
    return conditions
  end
  if X2Unit:UnitName("player") == target then
    return
  end
  local function MenuWhisper(conditions)
    if not UIParent:GetPermission(UIC_WHISPER) then
      return false
    end
    return true, targetPopup.whisper, popupProc_Whisper, nil
  end
  local function MenuWebMessenger(conditions)
    if not UIParent:GetPermission(UIC_WEB_MESSENGER) then
      return false
    end
    if not baselibLocale.useWebMessenger then
      return false
    end
    return true, targetPopup.requestMessenger, popupProc_WebMessenger, nil
  end
  local function MenuKickMember(conditions)
    if not UIParent:GetPermission(UIC_PARTY) then
      return false
    end
    if not conditions.self.isTeamOwner or not conditions.target.isMyTeam then
      return false
    end
    return true, GetKickMemberText(), popupProc_KickMemberByName, nil
  end
  local function MenuInviteTeam(conditions)
    if not UIParent:GetPermission(UIC_PARTY) then
      return false
    end
    if conditions.target.isMyJointTeam then
      return false
    end
    if conditions.self.isInTeam and not conditions.self.isTeamOwner then
      return false
    end
    if conditions.self.isRaidTeam then
      return false
    end
    return true, targetPopup.inviteParty, popupProc_InviteTeam, nil
  end
  local function MenuDelegateJointRaid(conditions)
    if not UIParent:GetPermission(UIC_RAID) then
      return false
    end
    if conditions.self.isPartyTeam then
      return false
    end
    if conditions.self.isInTeam and not conditions.self.isTeamOwner then
      return false
    end
    if conditions.self.isTeamJointLeader then
      if not conditions.target.isJointTeamOwner then
        return false
      end
    elseif not conditions.target.isMyTeam then
      return false
    end
    return true, GetOwnerChangeText(), popupProc_MakeOwner, nil
  end
  local function MenuInviteRaid(conditions)
    if not UIParent:GetPermission(UIC_RAID) then
      return false
    end
    if conditions.target.isMyJointTeam then
      return false
    end
    if conditions.self.isInTeam and not conditions.self.isTeamOwner then
      return false
    end
    if conditions.self.isPartyTeam then
      return false
    end
    return true, targetPopup.inviteRaidTeam, popupProc_InviteRaid, nil
  end
  local function MenuInviteRaidJoint(conditions)
    if not UIParent:GetPermission(UIC_RAID) then
      return false
    end
    if conditions.target.isMyJointTeam then
      return false
    end
    if conditions.self.isInTeam and not conditions.self.isTeamOwner then
      return false
    end
    if conditions.self.isPartyTeam then
      return false
    end
    if not data.jointable then
      return false
    end
    return true, GetCommonText("raid_joint_req_title"), popupProc_InviteRaidJoint, nil
  end
  local function MenuInviteSquad(conditions)
    if not X2Player:GetFeatureSet().squad or not UIParent:GetPermission(UIC_SQUAD) then
      return false
    end
    if not conditions.self.isSquadOwner then
      return false
    end
    return true, locale.squad.invite, popupProc_InviteSquad, nil
  end
  local function MenuInviteExpedition(conditions)
    if not UIParent:GetPermission(UIC_EXPEDITION) then
      return false
    end
    if conditions.target.isMyExpedMember or not conditions.self.canInviteExped then
      return false
    end
    return true, locale.expedition.invite, popupProc_InviteExpedition, nil
  end
  local function MenuAddFriend(conditions)
    if not UIParent:GetPermission(UIC_FRIEND) then
      return false
    end
    if conditions.target.isMyFriend then
      return false
    end
    return true, locale.friend.addFriend, popupProc_AddFriend, nil
  end
  local function MenuDeleteFriend(conditions)
    if not UIParent:GetPermission(UIC_FRIEND) then
      return false
    end
    if not conditions.target.isMyFriend then
      return false
    end
    return true, locale.friend.deleteFriend, popupProc_DeleteFriend, nil
  end
  local function MenuUnblockUser(conditions)
    if not UIParent:GetPermission(UIC_FRIEND) then
      return false
    end
    if not conditions.target.isBlocked then
      return false
    end
    return true, locale.community.unblock, popupProc_UnBlock, nil
  end
  local function MenuAddIgnore(conditions)
    if not UIParent:GetPermission(UIC_FRIEND) then
      return false
    end
    if conditions.target.isBlocked then
      return false
    end
    return true, locale.block.add, popupProc_AddIgnore, nil
  end
  local function MenuWebPlayDairy(conditions)
    if not UIParent:GetPermission(UIC_WEB_PLAY_DIARY) then
      return false
    end
    if not baselibLocale.useWebDiary then
      return false
    end
    return true, targetPopup.requestPlayDiary, popupProc_WebPlayDairy, nil
  end
  local function MenuInviteFamily(conditions)
    if not UIParent:GetPermission(UIC_FAMILY) then
      return false
    end
    return true, locale.family.add_family, popupProc_InviteFamily, nil
  end
  local function MenuReportSpammer(conditions)
    if not UIParent:GetPermission(UIC_FRIEND) then
      return false
    end
    if data.messageTimeStamp == nil or X2Player:GetFeatureSet().reportSpammer == false then
      return false
    end
    arg = {
      messageTimeStamp = data.messageTimeStamp,
      stickTo = stickTo
    }
    return true, GetUIText(COMMON_TEXT, "report_spammer"), popupProc_ReportSpammer, arg
  end
  local function MenuReportBadUser(conditions)
    if not UIParent:GetPermission(UIC_REPORT_BAD_USER) then
      return
    end
    if GetNewReportBadUser() == false or componentsLocale.useMenuReportBadUser == false then
      return false
    end
    return true, targetPopup.reportBadUser, popupProc_ReportBadUser, nil
  end
  local function MenuReportBadWordUser(conditions)
    if not UIParent:GetPermission(UIC_REPORT_BAD_USER) then
      return
    end
    if GetReportBadWordUser() == false then
      return false
    end
    return true, targetPopup.reportBadWordUser, popupProc_ReportBadWordUser, nil
  end
  local allMenuList = {
    [UR_FRIENDLY] = {
      MenuReportBadWordUser,
      MenuDelegateJointRaid,
      MenuKickMember,
      MenuInviteTeam,
      MenuInviteRaid,
      MenuInviteRaidJoint,
      MenuInviteSquad,
      MenuInviteFamily,
      MenuInviteExpedition,
      MenuAddFriend,
      MenuDeleteFriend,
      MenuAddIgnore,
      MenuUnblockUser,
      MenuWhisper,
      MenuWebPlayDairy,
      MenuWebMessenger,
      MenuReportBadUser,
      MenuReportSpammer
    },
    [UR_NEUTRAL] = {
      MenuReportBadWordUser,
      MenuKickMember,
      MenuInviteSquad,
      MenuInviteFamily,
      MenuAddFriend,
      MenuDeleteFriend,
      MenuAddIgnore,
      MenuUnblockUser,
      MenuWhisper,
      MenuWebPlayDairy,
      MenuWebMessenger,
      MenuReportBadUser,
      MenuReportSpammer
    },
    [UR_HOSTILE] = {
      MenuReportBadWordUser,
      MenuKickMember,
      MenuInviteSquad,
      MenuAddFriend,
      MenuDeleteFriend,
      MenuAddIgnore,
      MenuUnblockUser,
      MenuWebPlayDairy,
      MenuReportBadUser,
      MenuReportSpammer
    }
  }
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = target
  local unitName = target
  local conditions = MakeConditions(unitName)
  local menuList = allMenuList[data.relation]
  for i = 1, #menuList do
    local func = menuList[i]
    local use, menuTitle, menuProc, arg = func(conditions)
    if use then
      if arg == nil then
        arg = unitName
      else
        arg.unitName = unitName
      end
      popupInfo:AddInfo(menuTitle, menuProc, arg)
    end
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, nil, "BOTTOMLEFT", componentsLocale.popupMenu.offsetX, -140)
end
local function WatchTargetPopup(stickTo, target)
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo.target = "watchtarget"
  popupInfo:AddInfo(GetUIText(UNIT_FRAME_TEXT, "watch_target_release"), popupProc_ReleaseWatchTarget)
  local myMemberIndex = X2Team:GetTeamPlayerIndex()
  if not X2Team:IsRaidTeam() or X2Team:IsMyTeamOwner(myMemberIndex) then
    popupInfo:AddInfo(locale.unitFrame.overHeadMarker, popupProc_ActivateOverHeadMarkerPopupMenu, nil, true)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo, nil, "TOPLEFT", "BOTTOMRIGHT", componentsLocale.popupMenu.offsetX, -20)
end
function ActivatePopupMenu(stickTo, target, data)
  local myJointOrder = X2Team:GetMyTeamJointOrder()
  if target == "player" then
    PlayerPopup(stickTo)
  elseif target == "team" then
    if data.jointOrder == myJointOrder then
      TeamPopup(stickTo, data)
    else
      JointTeamPopup(stickTo, data)
    end
  elseif target == "target" then
    TargetPopup(stickTo, target, data)
  elseif target == "slave" then
    SlavePopup(stickTo, target)
  elseif IsMyPetTaret(target) or target == "mate" then
    MatePopup(stickTo, target)
  elseif target == "watchtarget" then
    WatchTargetPopup(stickTo)
  else
    UnitPopup(stickTo, target, data)
  end
end
function ActivateFriendMemberPopupMenu(stickTo, name, isInTeam, isOnline)
  if name == nil then
    return
  end
  local popupInfo = GetDefaultPopupInfoTable()
  local function MenuParty()
    if X2Team:IsPartyTeam() == true then
      if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true then
        popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
      end
    elseif X2Team:IsRaidTeam() == true then
      if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true or X2Team:IsMyTeamOwner(X2Team:GetTeamPlayerIndex()) == true then
        popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
      end
    else
      popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
      popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
    end
  end
  local friendMemberPopupMenuList = {
    online = {
      MenuParty,
      MenuSquadInviteOnly,
      MenuFriend,
      MenuBlockedUser,
      MenuWhisper,
      MenuPlayDairy,
      MenuMessage
    },
    offline = {
      MenuFriend,
      MenuBlockedUser,
      MenuPlayDairy,
      MenuMessage
    }
  }
  local friendMemberPopupMenuData = {name = name}
  local function CreateMenuList()
    if isOnline then
      return friendMemberPopupMenuList.online
    end
    return friendMemberPopupMenuList.offline
  end
  local menuList = CreateMenuList()
  for i = 1, #menuList do
    menuList[i](popupInfo, friendMemberPopupMenuData)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateBlockMemberPopupMenu(stickTo, name)
  if name == nil then
    return
  end
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo:AddInfo(locale.community.unblock, popupProc_UnBlock, name)
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateFamilyMemberPopupMenu(ownerWnd, stickTo, charId, name, title, isOnline)
  if name == nil then
    return
  end
  local popupInfo = GetDefaultPopupInfoTable()
  local function MenuParty()
    if isOnline == true then
      if X2Team:IsPartyTeam() == true then
        if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true then
          popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
        end
      elseif X2Team:IsRaidTeam() == true then
        if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true or X2Team:IsMyTeamOwner(X2Team:GetTeamPlayerIndex()) == true then
          popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
        end
      else
        popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
        popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
      end
    end
  end
  local function MenuOtherFamily()
    if X2Family:IsOwner() then
      local argTable = {
        ownerWnd,
        name,
        title
      }
      popupInfo:AddInfo(locale.family.change_owner, popupProc_ChangeFamilyOwner, name)
      popupInfo:AddInfo(locale.family.changeTitle, ShowChangeFamilyAppellation, argTable)
      popupInfo:AddInfo(GetCommonText("family_role_change"), popupProc_ActivateFamilyRolePopupMenu, name, true)
      popupInfo:AddInfo(locale.family.kick_member, popupProc_KickFamily, charId)
    end
  end
  local function MenuMineFamily()
    if X2Family:IsOwner() then
      local argTable = {
        ownerWnd,
        name,
        title
      }
      popupInfo:AddInfo(locale.family.changeTitle, ShowChangeFamilyAppellation, argTable)
    end
  end
  local function MenuLeaveFamily()
    popupInfo:AddInfo(locale.family.leave_family, popupProc_LeaveFamily)
  end
  local familyMemberPopupMenuList = {
    other = {
      MenuParty,
      MenuSquadInviteOnly,
      MenuOtherFamily,
      MenuWhisper,
      MenuPlayDairy,
      MenuMessage
    },
    mine = {
      MenuPlayDairy,
      MenuMineFamily,
      MenuLeaveFamily
    }
  }
  local familyMemberPopupMenuData = {name = name}
  local function CreateMenuList()
    if X2Unit:UnitName("player") ~= name then
      return familyMemberPopupMenuList.other
    end
    return familyMemberPopupMenuList.mine
  end
  local menuList = CreateMenuList()
  for i = 1, #menuList do
    menuList[i](popupInfo, familyMemberPopupMenuData)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateExpeditionMemberPopupMenu(stickTo, name, isInTeam, isOnline, expellable)
  if name == nil then
    return
  end
  local popupInfo = GetDefaultPopupInfoTable()
  local function MenuParty()
    if isInTeam == false then
      if X2Team:IsPartyTeam() == true then
        if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true then
          popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
        end
      elseif X2Team:IsRaidTeam() == true then
        if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true or X2Team:IsMyTeamOwner(X2Team:GetTeamPlayerIndex()) == true then
          popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
        end
      else
        popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
        popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
      end
    end
  end
  local function MenuKickFromExpedition()
    if expellable == true then
      popupInfo:AddInfo(componentsLocale:GetExpeditionExpelText(), popupProc_KickFromExpedition, name)
    end
  end
  local expeditionMemberPopupMenuList = {
    otherOnline = {
      MenuParty,
      MenuSquadInviteOnly,
      MenuKickFromExpedition,
      MenuWhisper,
      MenuPlayDairy,
      MenuMessage
    },
    otherOffline = {
      MenuKickFromExpedition,
      MenuWhisper,
      MenuPlayDairy,
      MenuMessage
    },
    mine = {MenuPlayDairy}
  }
  local expeditionMemberPopupMenuData = {name = name}
  local function CreateMenuList()
    if X2Unit:UnitName("player") ~= name then
      if isOnline then
        return expeditionMemberPopupMenuList.otherOnline
      else
        return expeditionMemberPopupMenuList.otherOffline
      end
    else
      return expeditionMemberPopupMenuList.mine
    end
    return nil
  end
  local menuList = CreateMenuList()
  if menuList == nil then
    return
  end
  for i = 1, #menuList do
    menuList[i](popupInfo, expeditionMemberPopupMenuData)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateNationMemberPopupMenu(stickTo, name, isOnline)
  if name == nil then
    return
  end
  local popupInfo = GetDefaultPopupInfoTable()
  local function MenuParty()
    if X2Team:IsPartyTeam() == true then
      if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true then
        popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
      end
    elseif X2Team:IsRaidTeam() == true then
      if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) == true or X2Team:IsMyTeamOwner(X2Team:GetTeamPlayerIndex()) == true then
        popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
      end
    else
      popupInfo:AddInfo(targetPopup.inviteParty, popupProc_InviteTeam, name)
      popupInfo:AddInfo(targetPopup.inviteRaidTeam, popupProc_InviteRaid, name)
    end
  end
  local function MenuKickFromExpedition()
    if expellable == true then
      popupInfo:AddInfo(componentsLocale:GetExpeditionExpelText(), popupProc_KickFromExpedition, name)
    end
  end
  local nationMemberPopupMenuList = {
    otherOnline = {
      MenuParty,
      MenuSquadInviteOnly,
      MenuWhisper,
      MenuPlayDairy,
      MenuMessage
    },
    otherOffline = {
      MenuWhisper,
      MenuPlayDairy,
      MenuMessage
    },
    mine = {MenuPlayDairy}
  }
  local nationMemberPopupMenuData = {name = name}
  local function CreateMenuList()
    if X2Unit:UnitName("player") ~= name then
      if isOnline then
        return nationMemberPopupMenuList.otherOnline
      else
        return nationMemberPopupMenuList.otherOffline
      end
    else
      return nationMemberPopupMenuList.mine
    end
    return nil
  end
  local menuList = CreateMenuList()
  if menuList == nil then
    return
  end
  for i = 1, #menuList do
    menuList[i](popupInfo, nationMemberPopupMenuData)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateSquadMemberPopupMenu(ownerWnd, stickTo, isMe, worldId, charId, charName)
  local popupInfo = GetDefaultPopupInfoTable()
  local function MenuMemberSquad(popupInfo, data)
    if not X2Player:GetFeatureSet().squad or not UIParent:GetPermission(UIC_SQUAD) or not X2Squad:HasMySquad() then
      return
    end
    if X2Squad:IsLeader() and not isMe then
      popupInfo:AddInfo(locale.squad.expel, popupProc_MemberExpelSquad, charId)
      popupInfo:AddInfo(locale.squad.delegate, popupProc_MemberDelegateSquad, charId)
    end
    if isMe then
      popupInfo:AddInfo(locale.squad.leave, popupProc_LeaveSquad)
    end
    local popupData = {}
    popupData.worldID = worldId
    popupData.charID = charId
    popupData.charName = charName
    popupInfo:AddInfo(GetUIText(COMMON_TEXT, "show_target_equipment"), popupProc_RequestRankerEquipItemInfo, popupData)
  end
  local list = {
    other = {MenuMemberSquad},
    mine = {MenuMemberSquad}
  }
  local function CreateMenuList()
    return list.mine
  end
  local menuList = CreateMenuList()
  for i = 1, #menuList do
    menuList[i](popupInfo, list)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateExpeditionRolePopupMenu(stickTo, name, roles, checkedIndex)
  local popupInfo = GetDefaultPopupInfoTable()
  for i = 1, #roles do
    local arg = {}
    arg.name = name
    arg.index = roles[i].role
    popupInfo:AddInfo(roles[i].name, popupProc_ChangeExpeditionRole, arg)
    popupInfo:AddRadioBtn(i == checkedIndex)
  end
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function ActivateRankerPopupMenu(stickTo, worldID, charID, charName)
  local popupInfo = GetDefaultPopupInfoTable()
  local popupData = {}
  popupData.worldID = worldID
  popupData.charID = charID
  popupData.charName = charName
  popupInfo:AddInfo(GetUIText(COMMON_TEXT, "show_target_equipment"), popupProc_RequestRankerEquipItemInfo, popupData)
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
