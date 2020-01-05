local JOINT_REQ_WIDTH = 430
local JOINT_REQ_HEIGHT = 360
local JOINT_RES_WIDTH = 430
local JOINT_RES_HEIGHT = 455
function SetViewOfRaidJointRequestFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local extend = 0
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(JOINT_REQ_WIDTH, JOINT_REQ_HEIGHT)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetCommonText("raid_joint_req_title"))
  window:SetCloseOnEscape(true)
  window:SetSounds("dialog_common")
  local context = window:CreateChildWidget("textbox", "context", 0, true)
  context:SetExtent(380, FONT_SIZE.LARGE)
  context.style:SetFontSize(FONT_SIZE.LARGE)
  context:SetAutoResize(true)
  context:SetText(GetCommonText("raid_joint_req_body"))
  context:AddAnchor("TOP", window, 0, titleMargin)
  ApplyTextColor(context, F_COLOR.GetColor("default"))
  if context:GetHeight() > FONT_SIZE.LARGE then
    extend = extend + context:GetHeight() - FONT_SIZE.LARGE
  end
  local topSection = window:CreateChildWidget("emptywidget", "topSection", 0, true)
  topSection:SetExtent(388, 97)
  topSection:AddAnchor("TOP", context, "BOTTOM", 0, 14)
  topSection.bg = CreateContentBackground(topSection, "TYPE2", "brown")
  topSection.bg:SetExtent(388, 97)
  topSection.bg:AddAnchor("CENTER", topSection, 0, 0)
  topSection.topBg = topSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_bottom", "background")
  topSection.topBg:SetTextureColor("default")
  topSection.topBg:SetExtent(388, 32)
  topSection.topBg:AddAnchor("TOP", topSection.bg, 0, 0)
  topSection.line = topSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "slim_line_01", "background")
  topSection.line:SetExtent(388, 1)
  topSection.line:AddAnchor("TOPLEFT", topSection.topBg, "BOTTOMLEFT", 0, 0)
  topSection.line:AddAnchor("TOPRIGHT", topSection.topBg, "BOTTOMRIGHT", 0, 0)
  topSection.leftBg = topSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_top_right", "background")
  topSection.leftBg:SetTextureColor("default")
  topSection.leftBg:SetExtent(122, 64)
  topSection.leftBg:AddAnchor("TOPLEFT", topSection.line, "BOTTOMLEFT", 0, 0)
  local topSecTitle = topSection:CreateChildWidget("label", "topSecTitle", 0, true)
  topSecTitle:SetExtent(360, FONT_SIZE.LARGE)
  topSecTitle.style:SetFontSize(FONT_SIZE.LARGE)
  topSecTitle:SetText(GetCommonText("raid_joint_req_target"))
  topSecTitle:AddAnchor("TOP", topSection.topBg, 0, 12)
  ApplyTextColor(topSecTitle, F_COLOR.GetColor("middle_title"))
  local topSec1stLabel = topSection:CreateChildWidget("label", "topSec1stLabel", 0, true)
  topSec1stLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  topSec1stLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec1stLabel.style:SetAlign(ALIGN_LEFT)
  topSec1stLabel:SetText(GetUIText(RAID_TEXT, "raid_owner"))
  topSec1stLabel:AddAnchor("TOPLEFT", topSection.leftBg, 14, 11)
  ApplyTextColor(topSec1stLabel, F_COLOR.GetColor("default"))
  local topSec2ndLabel = topSection:CreateChildWidget("label", "topSec2ndLabel", 0, true)
  topSec2ndLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  topSec2ndLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec2ndLabel.style:SetAlign(ALIGN_LEFT)
  topSec2ndLabel:SetText(GetCommonText("raid_member_count"))
  topSec2ndLabel:AddAnchor("TOPLEFT", topSec1stLabel, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(topSec2ndLabel, F_COLOR.GetColor("default"))
  local topSec1stContext = topSection:CreateChildWidget("label", "topSec1stContext", 0, true)
  topSec1stContext:SetExtent(240, FONT_SIZE.MIDDLE)
  topSec1stContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec1stContext.style:SetAlign(ALIGN_LEFT)
  topSec1stContext:AddAnchor("TOPLEFT", topSection.leftBg, "TOPRIGHT", 10, 11)
  ApplyTextColor(topSec1stContext, F_COLOR.GetColor("blue"))
  window.topSec1stContext = topSec1stContext
  local topSec2ndContext = topSection:CreateChildWidget("label", "topSec2ndContext", 0, true)
  topSec2ndContext:SetExtent(240, FONT_SIZE.MIDDLE)
  topSec2ndContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec2ndContext.style:SetAlign(ALIGN_LEFT)
  topSec2ndContext:AddAnchor("TOPLEFT", topSec1stContext, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(topSec2ndContext, F_COLOR.GetColor("blue"))
  window.topSec2ndContext = topSec2ndContext
  local bottomSection = window:CreateChildWidget("emptywidget", "bottomSection", 0, true)
  bottomSection:SetExtent(388, 97)
  bottomSection:AddAnchor("TOP", topSection, "BOTTOM", 0, 3)
  bottomSection.bg = CreateContentBackground(bottomSection, "TYPE2", "brown")
  bottomSection.bg:SetExtent(388, 97)
  bottomSection.bg:AddAnchor("CENTER", bottomSection, 0, 0)
  bottomSection.topBg = bottomSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_bottom", "background")
  bottomSection.topBg:SetTextureColor("default")
  bottomSection.topBg:SetExtent(388, 32)
  bottomSection.topBg:AddAnchor("TOP", bottomSection.bg, 0, 0)
  bottomSection.line = bottomSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "slim_line_01", "background")
  bottomSection.line:SetExtent(388, 1)
  bottomSection.line:AddAnchor("TOPLEFT", bottomSection.topBg, "BOTTOMLEFT", 0, 0)
  bottomSection.line:AddAnchor("TOPRIGHT", bottomSection.topBg, "BOTTOMRIGHT", 0, 0)
  local bottomSecTitle = bottomSection:CreateChildWidget("label", "context", 0, true)
  bottomSecTitle:SetExtent(360, FONT_SIZE.LARGE)
  bottomSecTitle.style:SetFontSize(FONT_SIZE.LARGE)
  bottomSecTitle:SetText(GetUIText(RAID_TEXT, "set_my_role"))
  bottomSecTitle:AddAnchor("TOP", bottomSection.topBg, 0, 12)
  ApplyTextColor(bottomSecTitle, F_COLOR.GetColor("middle_title"))
  local radioSetting = {
    {
      text = GetCommonText("raid_joint_owner"),
      image = {
        path = TEXTURE_PATH.HUD,
        key = "crown_gold"
      }
    },
    {
      text = GetCommonText("raid_joint_officer"),
      image = {
        path = TEXTURE_PATH.HUD,
        key = "crown_silver"
      }
    }
  }
  local checks = CreateRadioGroup(bottomSection:GetId() .. ".checks", bottomSection, "vertical")
  checks:AddAnchor("TOPLEFT", bottomSection, 14, 41)
  checks:SetAutoWidth(true)
  checks:SetData(radioSetting)
  checks:Check(1)
  window.leader = true
  window.checks = checks
  local function OnRadioChanged(index)
    window.leader = index == 1 and true or false
  end
  checks:SetHandler("OnRadioChanged", OnRadioChanged)
  local notice = window:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetExtent(380, FONT_SIZE.MIDDLE)
  notice.style:SetFontSize(FONT_SIZE.MIDDLE)
  notice:SetAutoResize(true)
  notice:SetText(GetCommonText("raid_joint_warning"))
  notice:AddAnchor("TOP", bottomSection, "BOTTOM", 0, 7)
  ApplyTextColor(notice, F_COLOR.GetColor("red"))
  if notice:GetHeight() > FONT_SIZE.MIDDLE then
    extend = extend + notice:GetHeight() - FONT_SIZE.MIDDLE
  end
  if extend > 0 then
    window:SetExtent(JOINT_REQ_WIDTH, JOINT_REQ_HEIGHT + extend)
  end
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
      X2Team:JointOk(window.leader)
    end
  end
  window:SetHandler("OnHide", OnHide)
  function window:Init(name, count)
    window.process = false
    topSec1stContext:SetText(name)
    topSec2ndContext:SetText(GetCommonText("people_count", tostring(count)))
  end
  return window
end
function SetViewOfRaidJointReponseFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(JOINT_RES_WIDTH, JOINT_RES_HEIGHT)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetCommonText("raid_joint_req_title"))
  window:SetCloseOnEscape(true)
  window:SetSounds("dialog_common")
  local context1 = window:CreateChildWidget("textbox", "context1", 0, true)
  context1:SetExtent(380, FONT_SIZE.MIDDLE)
  context1.style:SetFontSize(FONT_SIZE.MIDDLE)
  context1:SetAutoResize(true)
  context1:AddAnchor("TOP", window, 0, titleMargin)
  ApplyTextColor(context1, F_COLOR.GetColor("default"))
  local context2 = window:CreateChildWidget("label", "context2", 0, true)
  context2:SetExtent(380, FONT_SIZE.MIDDLE)
  context2.style:SetFontSize(FONT_SIZE.MIDDLE)
  context2:SetText(GetCommonText("raid_joint_res_body2"))
  context2:AddAnchor("TOP", context1, "BOTTOM", 0, 5)
  ApplyTextColor(context2, F_COLOR.GetColor("default"))
  local topSection = window:CreateChildWidget("emptywidget", "topSection", 0, true)
  topSection:SetExtent(388, 121)
  topSection:AddAnchor("TOP", context2, "BOTTOM", 0, 8)
  topSection.bg = CreateContentBackground(topSection, "TYPE2", "brown")
  topSection.bg:SetExtent(388, 121)
  topSection.bg:AddAnchor("CENTER", topSection, 0, 0)
  topSection.topBg = topSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_bottom", "background")
  topSection.topBg:SetTextureColor("default")
  topSection.topBg:SetExtent(388, 32)
  topSection.topBg:AddAnchor("TOP", topSection.bg, 0, 0)
  topSection.line = topSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "slim_line_01", "background")
  topSection.line:SetExtent(388, 1)
  topSection.line:AddAnchor("TOPLEFT", topSection.topBg, "BOTTOMLEFT", 0, 0)
  topSection.line:AddAnchor("TOPRIGHT", topSection.topBg, "BOTTOMRIGHT", 0, 0)
  topSection.leftBg = topSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_top_right", "background")
  topSection.leftBg:SetTextureColor("default")
  topSection.leftBg:SetExtent(122, 88)
  topSection.leftBg:AddAnchor("TOPLEFT", topSection.line, "BOTTOMLEFT", 0, 0)
  local topSecTitle = topSection:CreateChildWidget("label", "topSecTitle", 0, true)
  topSecTitle:SetExtent(360, FONT_SIZE.LARGE)
  topSecTitle.style:SetFontSize(FONT_SIZE.LARGE)
  topSecTitle:SetText(GetCommonText("raid_joint_res_target"))
  topSecTitle:AddAnchor("TOP", topSection.topBg, 0, 12)
  ApplyTextColor(topSecTitle, F_COLOR.GetColor("middle_title"))
  local topSec1stLabel = topSection:CreateChildWidget("label", "topSec1stLabel", 0, true)
  topSec1stLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  topSec1stLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec1stLabel.style:SetAlign(ALIGN_LEFT)
  topSec1stLabel:SetText(GetUIText(RAID_TEXT, "raid_owner"))
  topSec1stLabel:AddAnchor("TOPLEFT", topSection.leftBg, 14, 9)
  ApplyTextColor(topSec1stLabel, F_COLOR.GetColor("default"))
  local topSec2ndLabel = topSection:CreateChildWidget("label", "topSec2ndLabel", 0, true)
  topSec2ndLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  topSec2ndLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec2ndLabel.style:SetAlign(ALIGN_LEFT)
  topSec2ndLabel:SetText(GetCommonText("raid_member_count"))
  topSec2ndLabel:AddAnchor("TOPLEFT", topSec1stLabel, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(topSec2ndLabel, F_COLOR.GetColor("default"))
  local topSec3rdLabel = topSection:CreateChildWidget("label", "topSec3rdLabel", 0, true)
  topSec3rdLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  topSec3rdLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec3rdLabel.style:SetAlign(ALIGN_LEFT)
  topSec3rdLabel:SetText(GetCommonText("raid_joint_setted_role"))
  topSec3rdLabel:AddAnchor("TOPLEFT", topSec2ndLabel, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(topSec3rdLabel, F_COLOR.GetColor("default"))
  local topSec1stContext = topSection:CreateChildWidget("label", "topSec1stContext", 0, true)
  topSec1stContext:SetExtent(240, FONT_SIZE.MIDDLE)
  topSec1stContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec1stContext.style:SetAlign(ALIGN_LEFT)
  topSec1stContext:AddAnchor("TOPLEFT", topSection.leftBg, "TOPRIGHT", 10, 9)
  ApplyTextColor(topSec1stContext, F_COLOR.GetColor("blue"))
  local topSec2ndContext = topSection:CreateChildWidget("label", "topSec2ndContext", 0, true)
  topSec2ndContext:SetExtent(240, FONT_SIZE.MIDDLE)
  topSec2ndContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec2ndContext.style:SetAlign(ALIGN_LEFT)
  topSec2ndContext:AddAnchor("TOPLEFT", topSec1stContext, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(topSec2ndContext, F_COLOR.GetColor("default"))
  local topSecIcon = topSection:CreateDrawable(TEXTURE_PATH.HUD, "crown_gold", "artwork")
  topSecIcon:AddAnchor("LEFT", topSec3rdLabel, "RIGHT", 17, 0)
  local topSec3rdContext = topSection:CreateChildWidget("label", "topSec3rdContext", 0, true)
  topSec3rdContext:SetExtent(220, FONT_SIZE.MIDDLE)
  topSec3rdContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  topSec3rdContext.style:SetAlign(ALIGN_LEFT)
  topSec3rdContext:AddAnchor("LEFT", topSecIcon, "RIGHT", 5, 0)
  ApplyTextColor(topSec3rdContext, F_COLOR.GetColor("blue"))
  local bottomSection = window:CreateChildWidget("emptywidget", "bottomSection", 0, true)
  bottomSection:SetExtent(388, 121)
  bottomSection:AddAnchor("TOP", topSection, "BOTTOM", 0, 3)
  bottomSection.bg = CreateContentBackground(bottomSection, "TYPE2", "brown")
  bottomSection.bg:SetExtent(388, 121)
  bottomSection.bg:AddAnchor("CENTER", bottomSection, 0, 0)
  bottomSection.topBg = bottomSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_bottom", "background")
  bottomSection.topBg:SetTextureColor("default")
  bottomSection.topBg:SetExtent(388, 32)
  bottomSection.topBg:AddAnchor("TOP", bottomSection.bg, 0, 0)
  bottomSection.line = bottomSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "slim_line_01", "background")
  bottomSection.line:SetExtent(388, 1)
  bottomSection.line:AddAnchor("TOPLEFT", bottomSection.topBg, "BOTTOMLEFT", 0, 0)
  bottomSection.line:AddAnchor("TOPRIGHT", bottomSection.topBg, "BOTTOMRIGHT", 0, 0)
  bottomSection.leftBg = bottomSection:CreateDrawable(TEXTURE_PATH.DEFAULT, "bg_crop_top_right", "background")
  bottomSection.leftBg:SetTextureColor("default")
  bottomSection.leftBg:SetExtent(122, 88)
  bottomSection.leftBg:AddAnchor("TOPLEFT", bottomSection.line, "BOTTOMLEFT", 0, 0)
  local bottomSecTitle = bottomSection:CreateChildWidget("label", "context", 0, true)
  bottomSecTitle:SetExtent(360, FONT_SIZE.LARGE)
  bottomSecTitle.style:SetFontSize(FONT_SIZE.LARGE)
  bottomSecTitle:SetText(GetCommonText("raid_joint_res_source"))
  bottomSecTitle:AddAnchor("TOP", bottomSection.topBg, 0, 12)
  ApplyTextColor(bottomSecTitle, F_COLOR.GetColor("middle_title"))
  local bottomSec1stLabel = bottomSection:CreateChildWidget("label", "bottomSec1stLabel", 0, true)
  bottomSec1stLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  bottomSec1stLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomSec1stLabel.style:SetAlign(ALIGN_LEFT)
  bottomSec1stLabel:SetText(GetUIText(RAID_TEXT, "raid_owner"))
  bottomSec1stLabel:AddAnchor("TOPLEFT", bottomSection.leftBg, 14, 9)
  ApplyTextColor(bottomSec1stLabel, F_COLOR.GetColor("default"))
  local bottomSec2ndLabel = bottomSection:CreateChildWidget("label", "bottomSec2ndLabel", 0, true)
  bottomSec2ndLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  bottomSec2ndLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomSec2ndLabel.style:SetAlign(ALIGN_LEFT)
  bottomSec2ndLabel:SetText(GetCommonText("raid_member_count"))
  bottomSec2ndLabel:AddAnchor("TOPLEFT", bottomSec1stLabel, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(bottomSec2ndLabel, F_COLOR.GetColor("default"))
  local bottomSec3rdLabel = bottomSection:CreateChildWidget("label", "bottomSec3rdLabel", 0, true)
  bottomSec3rdLabel:SetExtent(100, FONT_SIZE.MIDDLE)
  bottomSec3rdLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomSec3rdLabel.style:SetAlign(ALIGN_LEFT)
  bottomSec3rdLabel:SetText(GetCommonText("raid_joint_setted_role"))
  bottomSec3rdLabel:AddAnchor("TOPLEFT", bottomSec2ndLabel, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(bottomSec3rdLabel, F_COLOR.GetColor("default"))
  local bottomSec1stContext = bottomSection:CreateChildWidget("label", "bottomSec1stContext", 0, true)
  bottomSec1stContext:SetExtent(240, FONT_SIZE.MIDDLE)
  bottomSec1stContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomSec1stContext.style:SetAlign(ALIGN_LEFT)
  bottomSec1stContext:AddAnchor("TOPLEFT", bottomSection.leftBg, "TOPRIGHT", 10, 9)
  ApplyTextColor(bottomSec1stContext, F_COLOR.GetColor("blue"))
  local bottomSec2ndContext = bottomSection:CreateChildWidget("label", "bottomSec2ndContext", 0, true)
  bottomSec2ndContext:SetExtent(240, FONT_SIZE.MIDDLE)
  bottomSec2ndContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomSec2ndContext.style:SetAlign(ALIGN_LEFT)
  bottomSec2ndContext:AddAnchor("TOPLEFT", bottomSec1stContext, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(bottomSec2ndContext, F_COLOR.GetColor("default"))
  local bottomSecIcon = bottomSection:CreateDrawable(TEXTURE_PATH.HUD, "crown_gold", "artwork")
  bottomSecIcon:AddAnchor("LEFT", bottomSec3rdLabel, "RIGHT", 17, 0)
  local bottomSec3rdContext = bottomSection:CreateChildWidget("label", "bottomSec3rdContext", 0, true)
  bottomSec3rdContext:SetExtent(220, FONT_SIZE.MIDDLE)
  bottomSec3rdContext.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomSec3rdContext.style:SetAlign(ALIGN_LEFT)
  bottomSec3rdContext:AddAnchor("LEFT", bottomSecIcon, "RIGHT", 5, 0)
  ApplyTextColor(bottomSec3rdContext, F_COLOR.GetColor("blue"))
  local notice = window:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetExtent(380, FONT_SIZE.MIDDLE)
  notice:SetAutoResize(true)
  notice.style:SetFontSize(FONT_SIZE.MIDDLE)
  notice:SetText(GetCommonText("raid_joint_warning"))
  notice:AddAnchor("TOP", bottomSection, "BOTTOM", 0, 7)
  ApplyTextColor(notice, F_COLOR.GetColor("red"))
  if notice:GetHeight() > FONT_SIZE.MIDDLE then
    local extend = notice:GetHeight() - FONT_SIZE.MIDDLE
    window:SetExtent(JOINT_RES_WIDTH, JOINT_RES_HEIGHT + extend)
  end
  local noticeTime = window:CreateChildWidget("label", "noticeTime", 0, true)
  noticeTime:SetExtent(380, FONT_SIZE.MIDDLE)
  noticeTime.style:SetFontSize(FONT_SIZE.MIDDLE)
  noticeTime:AddAnchor("TOP", notice, "BOTTOM", 0, 10)
  ApplyTextColor(noticeTime, F_COLOR.GetColor("red"))
  window.process = false
  window.timeout = false
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
      X2Team:JointOk(window.leader)
    else
      X2Team:JointCancel(window.leader, window.timeout)
    end
  end
  window:SetHandler("OnHide", OnHide)
  function window:Init(name, count, leader)
    window.process = false
    window.timeout = false
    window.leader = leader
    if RaidJointRequest ~= nil then
      RaidJointRequest:Show(false)
    end
    context1:SetText(GetCommonText("raid_joint_res_body1", F_COLOR.GetColor("blue", true), name))
    topSec1stContext:SetText(name)
    topSec2ndContext:SetText(GetCommonText("people_count", tostring(count)))
    topSecIcon:SetTextureInfo(leader and "crown_silver" or "crown_gold")
    if not leader or not GetCommonText("raid_joint_officer") then
    end
    topSec3rdContext:SetText((GetCommonText("raid_joint_owner")))
    local myTeamOwnerIndex = X2Team:GetOwnerIndex(X2Team:GetMyTeamJointOrder())
    local myTeamOwnerName = X2Team:GetTeamMemberName(X2Team:GetMyTeamJointOrder(), myTeamOwnerIndex)
    local myTeamCount = X2Team:CountTeamMembers(X2Team:GetMyTeamJointOrder())
    bottomSec1stContext:SetText(myTeamOwnerName)
    bottomSec2ndContext:SetText(GetCommonText("people_count", tostring(myTeamCount)))
    bottomSecIcon:SetTextureInfo(leader and "crown_gold" or "crown_silver")
    if not leader or not GetCommonText("raid_joint_owner") then
    end
    bottomSec3rdContext:SetText((GetCommonText("raid_joint_officer")))
    window.time = 0
    function window:OnUpdate(dt)
      local REPLY_TIMEOUT = 60000
      self.time = self.time + dt
      if REPLY_TIMEOUT < self.time then
        self:ReleaseHandler("OnUpdate")
        window.timeout = true
        RightButtonLeftClickFunc()
      else
        local remainTime = math.floor((REPLY_TIMEOUT - self.time + 999) / 1000)
        if remainTime > 0 then
          local MIN = 60
          dateFormat = {}
          dateFormat.year = 0
          dateFormat.month = 0
          dateFormat.day = 0
          dateFormat.hour = 0
          dateFormat.minute = math.floor(remainTime / MIN)
          if 0 < dateFormat.minute then
            remainTime = remainTime - dateFormat.minute * MIN or remainTime
          end
          dateFormat.second = remainTime
          local remainTimeString = locale.time.GetRemainDateToDateFormat(dateFormat, DEFAULT_FORMAT_FILTER + FORMAT_FILTER.SECOND)
          noticeTime:SetText(string.format("%s : %s", GetUIText(TOOLTIP_TEXT, "left_time"), remainTimeString))
        end
      end
    end
    window:SetHandler("OnUpdate", window.OnUpdate)
  end
  return window
end
