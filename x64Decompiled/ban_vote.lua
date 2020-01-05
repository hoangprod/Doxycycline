local BAN_VOTE_ANNOUNCE_WIDTH = 430
local BAN_VOTE_ANNOUNCE_HEIGHT = 411
local BAN_VOTE_ANNOUNCE_TOP_HEIGHT = 75
local BAN_VOTE_ANNOUNCE_BOTTOM_HEIGHT = 147
local BAN_VOTE_PARTICIPATE_WIDTH = 300
local BAN_VOTE_PARTICIPATE_HEIGHT = 340
local BAN_VOTE_PARTICIPATE_TOP_HEIGHT = 76
local BAN_VOTE_PARTICIPATE_BOTTOM_HEIGHT = 76
local offset = {x = -130, y = 0}
local voteRadioData = {
  {
    text = GetCommonText("ban_vote_reason_non_participate"),
    value = BRT_NON_PARTICIPATE
  },
  {
    text = GetCommonText("ban_vote_reason_no_manner_chat"),
    value = BRT_NO_MANNER_CHAT
  },
  {
    text = GetCommonText("ban_vote_reason_cheating"),
    value = BRT_CHEATING
  },
  {
    text = GetCommonText("ban_vote_reason_chilling_effect"),
    value = BRT_CHILLING_EFFECT
  }
}
local function SetBanVoteAnnounce(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(BAN_VOTE_ANNOUNCE_WIDTH, BAN_VOTE_ANNOUNCE_HEIGHT)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(GetCommonText("ban_vote_announce_title"))
  window:SetCloseOnEscape(true)
  window:SetSounds("dialog_common")
  local sideMargin, titleMargin = GetWindowMargin()
  local contentWidth = window:GetWidth() - sideMargin * 2
  local context = window:CreateChildWidget("textbox", "context", 0, true)
  context:SetExtent(contentWidth, FONT_SIZE.LARGE)
  context:SetWidth(contentWidth)
  context.style:SetFontSize(FONT_SIZE.LARGE)
  context:SetAutoResize(true)
  context:SetText(GetCommonText("ban_vote_announce_body"))
  context:AddAnchor("TOP", window, 0, titleMargin)
  ApplyTextColor(context, F_COLOR.GetColor("default"))
  local data = {
    title = GetCommonText("ban_target")
  }
  local topSection = W_MODULE:Create("topSection", window, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  topSection:AddAnchor("TOP", context, "BOTTOM", 0, 15)
  local topSecName = topSection:CreateChildWidget("label", "top", 0, true)
  topSecName:SetHeight(FONT_SIZE.MIDDLE)
  topSecName.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(topSecName, F_COLOR.GetColor("blue"))
  topSection:AddBody(topSecName)
  local data = {
    title = GetCommonText("ban_vote_reason")
  }
  local bottomSection = W_MODULE:Create("bottomSection", window, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  bottomSection:AddAnchor("TOP", topSection, "BOTTOM", 0, 5)
  local checks = CreateRadioGroup(bottomSection:GetId() .. ".checks", bottomSection, "vertical")
  checks:Check(1)
  window.checks = checks
  bottomSection:AddBody(checks)
  checks:SetData(voteRadioData)
  bottomSection:Refresh()
  local notice = window:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  notice.style:SetFontSize(FONT_SIZE.MIDDLE)
  notice:SetAutoResize(true)
  notice:SetText(GetCommonText("ban_vote_announce_notice"))
  ApplyTextColor(notice, F_COLOR.GetColor("red"))
  local noticeMargin = 10
  notice:AddAnchor("TOP", bottomSection, "BOTTOM", 0, noticeMargin)
  window.process = false
  local function LeftButtonLeftClickFunc()
    window.process = true
    window:Show(false)
  end
  local function RightButtonLeftClickFunc()
    window.process = false
    window:Show(false)
  end
  local info = {leftButtonLeftClickFunc = LeftButtonLeftClickFunc, rightButtonLeftClickFunc = RightButtonLeftClickFunc}
  CreateWindowDefaultTextButtonSet(window, info)
  local function OnHide()
    if window.process then
      X2Unit:BanVoteTarget(tostring(window.targetId), BANVOTE_TYPE_START_VOTE, window.checks:GetChecked())
    else
      X2Unit:BanVoteTarget(tostring(window.targetId), BANVOTE_TYPE_START_VOTE, BRT_NO_REASON)
    end
  end
  window:SetHandler("OnHide", OnHide)
  function window:Init(param)
    window.process = false
    window.targetId = 0
    if param[1] ~= nil then
      window.targetId = param[1]
    end
    if param[2] ~= nil then
      window.targetName = param[2]
      topSecName:SetText(window.targetName)
    end
    local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, notice)
    height = height + MARGIN.WINDOW_SIDE + window.leftButton:GetHeight() + noticeMargin
    window:SetHeight(height)
  end
  return window
end
local BanVoteAnnounce = SetBanVoteAnnounce("banVoteAnnounce", "UIParent")
local banVoteAnnounceEvents = {
  BAN_VOTE_ANNOUNCE = function(param)
    BanVoteAnnounce:Show(true)
    BanVoteAnnounce:Init(param)
  end,
  LEFT_LOADING = function()
    BanVoteAnnounce:Show(false)
  end
}
BanVoteAnnounce:SetHandler("OnEvent", function(this, event, ...)
  banVoteAnnounceEvents[event](...)
end)
RegistUIEvent(BanVoteAnnounce, banVoteAnnounceEvents)
local function SetBanVoteParticipate(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(BAN_VOTE_PARTICIPATE_WIDTH, BAN_VOTE_PARTICIPATE_HEIGHT)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(GetCommonText("ban_vote_announce_title"))
  window:SetCloseOnEscape(true)
  window:SetSounds("dialog_common")
  local sideMargin, titleMargin = GetWindowMargin()
  local contentWidth = window:GetWidth() - sideMargin * 2
  local context = window:CreateChildWidget("textbox", "context", 0, true)
  context:SetExtent(contentWidth, FONT_SIZE.LARGE)
  context:SetWidth(contentWidth)
  context.style:SetFontSize(FONT_SIZE.LARGE)
  context:SetAutoResize(true)
  context:AddAnchor("TOP", window, 0, titleMargin)
  ApplyTextColor(context, F_COLOR.GetColor("default"))
  local data = {
    title = GetCommonText("ban_target")
  }
  local topSection = W_MODULE:Create("topSection", window, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  topSection:AddAnchor("TOP", context, "BOTTOM", 0, 15)
  local topSecName = topSection:CreateChildWidget("label", "topSecName", 0, true)
  topSecName:SetHeight(FONT_SIZE.MIDDLE)
  topSecName.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(topSecName, F_COLOR.GetColor("blue"))
  topSection:AddBody(topSecName)
  local data2 = {
    title = GetCommonText("ban_vote_reason")
  }
  local bottomSection = W_MODULE:Create("bottomSection", window, WINDOW_MODULE_TYPE.TITLE_BOX, data2)
  bottomSection:AddAnchor("TOP", topSection, "BOTTOM", 0, 5)
  local bottomSecReason = bottomSection:CreateChildWidget("textbox", "bottomSecReason", 0, true)
  bottomSecReason:SetHeight(FONT_SIZE.MIDDLE)
  bottomSecReason:SetAutoResize(true)
  ApplyTextColor(bottomSecReason, F_COLOR.GetColor("default"))
  bottomSection:AddBody(bottomSecReason)
  local notice = window:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  notice.style:SetFontSize(FONT_SIZE.MIDDLE)
  notice:SetAutoResize(true)
  notice:SetText(GetCommonText("ban_vote_participate_notice"))
  ApplyTextColor(notice, F_COLOR.GetColor("red"))
  window.process = false
  local function LeftButtonLeftClickFunc()
    window.process = true
    window:Show(false)
  end
  local function RightButtonLeftClickFunc()
    window.process = false
    window:Show(false)
  end
  local info = {
    leftButtonLeftClickFunc = LeftButtonLeftClickFunc,
    rightButtonLeftClickFunc = RightButtonLeftClickFunc,
    leftButtonStr = GetCommonText("agree"),
    rightButtonStr = GetCommonText("against")
  }
  CreateWindowDefaultTextButtonSet(window, info)
  local noticeMargin = 20
  notice:AddAnchor("TOP", bottomSection, "BOTTOM", 0, noticeMargin)
  local function OnHide()
    if window.process and window.reason ~= nil then
      X2Unit:BanVoteTarget(tostring(window.targetId), BANVOTE_TYPE_VOTE_AGREE, window.reason)
    else
      X2Unit:BanVoteTarget(tostring(window.targetId), BANVOTE_TYPE_VOTE_CLEAR, BRT_NO_REASON)
    end
  end
  window:SetHandler("OnHide", OnHide)
  function window:Init(param)
    window.process = false
    window.targetId = 0
    if param[1] ~= nil then
      window.targetId = param[1]
    end
    if param[2] ~= nil then
      window.targetName = param[2]
      topSecName:SetText(window.targetName)
    end
    window.reason = 0
    if param[3] ~= nil then
      window.reason = param[3]
      local reasonText = voteRadioData[window.reason].text
      if reasonText ~= nil then
        bottomSecReason:SetText(reasonText)
        bottomSection:Refresh()
      end
    end
    if param[4] ~= nil then
      window.context:SetText(GetCommonText("ban_vote_participate_body", param[4]))
    end
    local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, notice)
    height = height + MARGIN.WINDOW_SIDE + window.leftButton:GetHeight() + noticeMargin
    window:SetHeight(height)
  end
  return window
end
local BanVoteParticipate = SetBanVoteParticipate("banVoteParticipate", "UIParent")
local banVoteParticipateEvents = {
  BAN_VOTE_PARTICIPATE = function(param)
    BanVoteParticipate:RemoveAllAnchors()
    BanVoteParticipate:AddAnchor("RIGHT", offset.x, offset.y)
    BanVoteParticipate:Show(true)
    BanVoteParticipate:Init(param)
  end,
  LEFT_LOADING = function()
    BanVoteParticipate:Show(false)
  end
}
BanVoteParticipate:SetHandler("OnEvent", function(this, event, ...)
  banVoteParticipateEvents[event](...)
end)
RegistUIEvent(BanVoteParticipate, banVoteParticipateEvents)
local function BanPlayerResult(param)
  local success = ture
  if param[1] ~= nil then
    success = param[1]
  end
  local type = "success"
  if success ~= true then
    type = "fail"
  end
  if BanVoteParticipate ~= nil and BanVoteParticipate:IsVisible() then
    BanVoteParticipate:Show(false)
  end
  local func = locale.banPlayer.msgFunc[type]
  if func ~= nil then
    local name = param[2]
    if name ~= nil and name ~= "" then
      local notifyMsg = func(name)
      if notifyMsg ~= nil then
        X2Chat:DispatchChatMessage(CMF_PARTY_AND_RAID_INFO, notifyMsg)
      end
    end
  end
end
UIParent:SetEventHandler("BAN_PLAYER_RESULT", BanPlayerResult)
