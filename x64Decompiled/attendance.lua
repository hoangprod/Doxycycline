local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateAdditionalRewardWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local count = 4
  local bg = wnd:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_ATTENDANCE, "arch_bg", "background")
  bg:AddAnchor("BOTTOM", wnd, 0, 0)
  local w, h = bg:GetExtent()
  wnd:SetExtent(w, h)
  wnd.additionalRewardBtns = {}
  local left = 8
  for i = 1, count do
    local additionalRewardBg = wnd:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_ATTENDANCE, "arch_default_bg", "background")
    additionalRewardBg:AddAnchor("TOPLEFT", wnd, left, 6)
    left = left + (8 + additionalRewardBg:GetWidth())
    local additionalRewardLabel = wnd:CreateChildWidget("label", "additionalRewardBtns[" .. i .. "].label", 0, true)
    additionalRewardLabel:SetHeight(FONT_SIZE.MIDDLE)
    additionalRewardLabel.style:SetAlign(ALIGN_LEFT)
    additionalRewardLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    additionalRewardLabel:SetAutoResize(true)
    ApplyTextColor(additionalRewardLabel, F_COLOR.GetColor("green"))
    additionalRewardLabel:AddAnchor("TOP", additionalRewardBg, 0, 5)
    local additionalRewardBtn = CreateItemIconButton("additionalRewardBtns[" .. i .. "]", wnd)
    additionalRewardBtn:SetExtent(34, 34)
    additionalRewardBtn:AddAnchor("TOP", additionalRewardLabel, "BOTTOM", 0, 4)
    function additionalRewardBtn:Check(check)
      if check then
        self.bg:SetTextureInfo("arch_default_complete")
        ApplyTextColor(self.label, FONT_COLOR.WHITE)
      else
        self.bg:SetTextureInfo("arch_default_bg")
        ApplyTextColor(self.label, F_COLOR.GetColor("green"))
      end
    end
    wnd.additionalRewardBtns[i] = additionalRewardBtn
    wnd.additionalRewardBtns[i].bg = additionalRewardBg
    wnd.additionalRewardBtns[i].label = additionalRewardLabel
  end
  function wnd:SetRewardInfos(infos)
    for i = 1, #wnd.additionalRewardBtns do
      wnd.additionalRewardBtns[i]:Show(false)
    end
    for i = 1, #wnd.additionalRewardBtns do
      if i > #infos then
        return
      end
      wnd.additionalRewardBtns[i]:Show(true)
      wnd.additionalRewardBtns[i].count = infos[i].dayCount
      wnd.additionalRewardBtns[i].label:SetText(tostring(infos[i].dayCount))
      wnd.additionalRewardBtns[i]:SetItemInfo(infos[i])
      wnd.additionalRewardBtns[i]:SetStack(infos[i].itemCount)
      local itemInfo = X2Item:GetItemInfoByType(infos[i].itemType)
      wnd.additionalRewardBtns[i]:SetTooltip(itemInfo)
    end
  end
  function wnd:CheckRewardState(currentCount)
    for i = 1, #wnd.additionalRewardBtns do
      if wnd.additionalRewardBtns[i].count ~= nil then
        if currentCount >= wnd.additionalRewardBtns[i].count then
          wnd.additionalRewardBtns[i]:SetAlpha(1)
          wnd.additionalRewardBtns[i]:Check(true)
        else
          wnd.additionalRewardBtns[i]:SetAlpha(0.7)
          wnd.additionalRewardBtns[i]:Check(false)
        end
      end
    end
  end
  return wnd
end
local CreateAttendanceDescWnd = function(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_COMMON, "image", "background")
  bg:AddAnchor("TOP", wnd, 0, 0)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.XLARGE)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  title:SetText(GetCommonText("attendance"))
  title:AddAnchor("TOP", wnd, 0, 30)
  local desc = wnd:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetAutoResize(true)
  desc:SetWidth(286)
  desc.style:SetAlign(ALIGN_CENTER)
  desc.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(desc, FONT_COLOR.BROWN)
  desc:SetText(GetCommonText("attendance_desc1"))
  desc:AddAnchor("TOP", title, "BOTTOM", 0, 20)
  local desc2 = wnd:CreateChildWidget("textbox", "desc2", 0, true)
  desc2:SetAutoResize(true)
  desc2:SetWidth(286)
  desc2.style:SetAlign(ALIGN_CENTER)
  desc2.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(desc2, FONT_COLOR.BROWN)
  desc2:SetText(GetCommonText("attendance_desc2"))
  desc2:AddAnchor("TOP", desc, "BOTTOM", 0, 23)
  local additionalRewardWnd = CreateAdditionalRewardWnd("additionalRewardWnd", wnd)
  additionalRewardWnd:AddAnchor("BOTTOM", wnd, 0, -11)
  local additionalRewardTitle = wnd:CreateChildWidget("label", "additionalRewardTitle", 0, true)
  additionalRewardTitle:SetAutoResize(true)
  additionalRewardTitle:SetHeight(FONT_SIZE.MIDDLE)
  additionalRewardTitle.style:SetAlign(ALIGN_LEFT)
  additionalRewardTitle.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(additionalRewardTitle, F_COLOR.GetColor("green"))
  additionalRewardTitle:SetText(GetCommonText("attendance_additional_reward"))
  additionalRewardTitle:AddAnchor("BOTTOMLEFT", additionalRewardWnd, "TOPLEFT", 5, -8)
  local count = wnd:CreateChildWidget("label", "count", 0, true)
  count:SetAutoResize(true)
  count:SetHeight(FONT_SIZE.MIDDLE)
  count.style:SetAlign(ALIGN_RIGHT)
  count.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(count, F_COLOR.GetColor("bright_blue", false))
  count:AddAnchor("BOTTOMRIGHT", additionalRewardWnd, "TOPRIGHT", -5, -8)
  function wnd:CheckRewardState(attendedDayCount)
    count:SetText(GetCommonText("attendance_count") .. attendedDayCount)
    additionalRewardWnd:CheckRewardState(attendedDayCount)
  end
  return wnd
end
local CreateSingleAttendanceWnd = function(id, idx, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, idx, true)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_ATTENDANCE, "default_bg", "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local countLabel = wnd:CreateChildWidget("label", "countLabel", 0, true)
  countLabel:SetAutoResize(true)
  countLabel:SetHeight(FONT_SIZE.LARGE)
  countLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
  ApplyTextColor(countLabel, FONT_COLOR.TITLE)
  countLabel:AddAnchor("TOPLEFT", wnd, 8, 8)
  local rewardBtn = CreateItemIconButton("rewardBtn", wnd)
  rewardBtn:SetExtent(34, 34)
  rewardBtn:AddAnchor("TOPLEFT", wnd, 30, 42)
  function wnd:SetBgTexture(key)
    if key == "bonus_complete" or key == "default_complete" then
      rewardBtn:SetAlpha(1)
      countLabel:SetAlpha(0.55)
      ApplyTextColor(countLabel, FONT_COLOR.WHITE)
    elseif key == "today" then
      rewardBtn:SetAlpha(0.7)
      countLabel:SetAlpha(1)
      ApplyTextColor(countLabel, FONT_COLOR.BLUE)
    elseif key == "today_bonus" or key == "bonus_bg" then
      rewardBtn:SetAlpha(0.7)
      countLabel:SetAlpha(1)
      ApplyTextColor(countLabel, F_COLOR.GetColor("yellow"))
    elseif key == "default_bg" then
      rewardBtn:SetAlpha(0.7)
      countLabel:SetAlpha(1)
      ApplyTextColor(countLabel, FONT_COLOR.MIDDLE_TITLE)
    end
    bg:SetTextureInfo(key)
  end
  function wnd:SetRewardInfo(info)
    countLabel:SetText(tostring(info.dayCount))
    rewardBtn:SetItemInfo(info)
    rewardBtn:SetStack(info.itemCount)
    local itemInfo = X2Item:GetItemInfoByType(info.itemType)
    itemInfo.itemGrade = info.itemGrade
    rewardBtn:SetTooltip(itemInfo)
  end
  return wnd
end
local listWidth = 547
local listHeight = 377
local singleWidth = 74
local singleHeight = 91
local vertGap = 5
local horiGap = 4
local attendMax = ATTENDANCE_VER_COUNT * ATTENDANCE_HORI_COUNT
local function CreateAttendanceListWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local listWnd = parent:CreateChildWidget("emptywidget", "listWnd", 0, true)
  listWnd:SetExtent(listWidth, listHeight)
  listWnd:AddAnchor("BOTTOM", wnd, 0, -51)
  local monthLabel = wnd:CreateChildWidget("label", "monthLabel", 0, true)
  monthLabel:SetAutoResize(true)
  monthLabel:SetHeight(FONT_SIZE.XLARGE)
  monthLabel.style:SetAlign(ALIGN_LEFT)
  monthLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(monthLabel, FONT_COLOR.MIDDLE_TITLE)
  monthLabel:AddAnchor("BOTTOMLEFT", listWnd, "TOPLEFT", 0, -10)
  local noticeLabel = wnd:CreateChildWidget("label", "noticeLabel", 0, true)
  noticeLabel:SetAutoResize(true)
  noticeLabel:SetHeight(FONT_SIZE.MIDDLE)
  noticeLabel.style:SetAlign(ALIGN_RIGHT)
  noticeLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(noticeLabel, FONT_COLOR.DEFAULT)
  noticeLabel:SetText(GetCommonText("attendance_notice"))
  noticeLabel:AddAnchor("BOTTOMRIGHT", listWnd, "TOPRIGHT", 0, -10)
  local attendBtn = wnd:CreateChildWidget("button", "attendBtn", 0, true)
  attendBtn:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  attendBtn:SetText(GetCommonText("attendance_button"))
  ApplyButtonSkin(attendBtn, BUTTON_BASIC.DEFAULT)
  local serverTimeLabel = wnd:CreateChildWidget("label", "serverTimeLabel", 0, true)
  serverTimeLabel:SetAutoResize(true)
  serverTimeLabel:SetHeight(FONT_SIZE.MIDDLE)
  serverTimeLabel.style:SetAlign(ALIGN_LEFT)
  serverTimeLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(serverTimeLabel, FONT_COLOR.GRAY)
  serverTimeLabel:AddAnchor("TOPLEFT", listWnd, "BOTTOMLEFT", 0, 29)
  serverTimeLabel.delay = 5000
  function serverTimeLabel:OnUpdate(dt)
    serverTimeLabel.delay = serverTimeLabel.delay + dt
    if serverTimeLabel.delay > 5000 then
      serverTimeLabel.delay = 0
      local serverTime = UI:GetServerTimeTable()
      local serverTimeText = locale.time.GetDateToDateFormat(serverTime)
      serverTimeLabel:SetText(string.format("%s%s", GetUIText(COMMON_TEXT, "attendanceServerTime"), serverTimeText))
    end
  end
  serverTimeLabel:SetHandler("OnUpdate", serverTimeLabel.OnUpdate)
  for i = 1, attendMax do
    local row = math.floor(i / ATTENDANCE_HORI_COUNT)
    local column = math.fmod(i, ATTENDANCE_HORI_COUNT)
    local singleAttendanceWnd = CreateSingleAttendanceWnd("singleAttendanceWnd", i, listWnd)
    singleAttendanceWnd:SetExtent(singleWidth, singleHeight)
    if i == 1 then
      singleAttendanceWnd:AddAnchor("TOPLEFT", listWnd, 0, 0)
    elseif column == 1 then
      local nextLineGap = row * (singleHeight + horiGap)
      singleAttendanceWnd:AddAnchor("TOPLEFT", listWnd, 0, nextLineGap)
    else
      singleAttendanceWnd:AddAnchor("LEFT", listWnd.singleAttendanceWnd[i - 1], "RIGHT", vertGap, 0)
    end
  end
  local months = {
    GetUIText(COMMON_TEXT, "january"),
    GetUIText(COMMON_TEXT, "february"),
    GetUIText(COMMON_TEXT, "march"),
    GetUIText(COMMON_TEXT, "april"),
    GetUIText(COMMON_TEXT, "may"),
    GetUIText(COMMON_TEXT, "june"),
    GetUIText(COMMON_TEXT, "july"),
    GetUIText(COMMON_TEXT, "august"),
    GetUIText(COMMON_TEXT, "september"),
    GetUIText(COMMON_TEXT, "october"),
    GetUIText(COMMON_TEXT, "november"),
    GetUIText(COMMON_TEXT, "december")
  }
  function wnd:SetRewardInfos(rewardInfos)
    local serverTime = X2Time:GetServerTime()
    monthLabel:SetText(months[serverTime.month])
    for i = 1, #rewardInfos do
      if i <= attendMax then
        listWnd.singleAttendanceWnd[rewardInfos[i].dayCount]:SetRewardInfo(rewardInfos[i])
        listWnd.singleAttendanceWnd[rewardInfos[i].dayCount]:Show(true)
      end
    end
    if #rewardInfos < #listWnd.singleAttendanceWnd then
      for i = #rewardInfos + 1, #listWnd.singleAttendanceWnd do
        listWnd.singleAttendanceWnd[i]:Show(false)
      end
    end
  end
  function attendBtn:OnClick()
    X2EventCenter:AddAttendance()
    attendBtn:Enable(false)
  end
  attendBtn:SetHandler("OnClick", attendBtn.OnClick)
  function wnd:CheckRewardState(attendedDayCount)
    if attendedDayCount > attendMax then
      attendedDayCount = attendMax
    end
    if math.fmod(attendedDayCount, ATTENDANCE_HORI_COUNT) == 0 then
      listWnd.singleAttendanceWnd[attendedDayCount]:SetBgTexture("bonus_complete")
    else
      listWnd.singleAttendanceWnd[attendedDayCount]:SetBgTexture("default_complete")
    end
  end
  function wnd:CheckAttendable(rewardInfos)
    local attendable = X2EventCenter:CheckAttendable()
    attendBtn:Enable(attendable)
    if rewardInfos.attendedDayCount > attendMax then
      rewardInfos.attendedDayCount = attendMax
    end
    for i = 1, #listWnd.singleAttendanceWnd do
      if i <= rewardInfos.attendedDayCount then
        if math.fmod(i, ATTENDANCE_HORI_COUNT) == 0 then
          listWnd.singleAttendanceWnd[i]:SetBgTexture("bonus_complete")
        else
          listWnd.singleAttendanceWnd[i]:SetBgTexture("default_complete")
        end
      elseif i == rewardInfos.attendedDayCount + 1 and attendable then
        if math.fmod(i, ATTENDANCE_HORI_COUNT) == 0 then
          listWnd.singleAttendanceWnd[i]:SetBgTexture("today_bonus")
        else
          listWnd.singleAttendanceWnd[i]:SetBgTexture("today")
        end
      elseif rewardInfos[i] == nil then
        listWnd.singleAttendanceWnd[i]:Show(false)
      elseif math.fmod(i, ATTENDANCE_HORI_COUNT) == 0 then
        listWnd.singleAttendanceWnd[i]:SetBgTexture("bonus_bg")
      else
        listWnd.singleAttendanceWnd[i]:SetBgTexture("default_bg")
      end
    end
  end
  return wnd
end
function CreateAttendanceWnd(parent)
  parent.isAttendanceWnd = true
  local descWnd = CreateAttendanceDescWnd("attendanceDesc", parent)
  descWnd:SetWidth(286)
  descWnd:AddAnchor("TOPLEFT", parent, 0, 16)
  descWnd:AddAnchor("BOTTOMLEFT", parent, 0, 0)
  local listWnd = CreateAttendanceListWnd("attendanceListWnd", parent)
  listWnd:AddAnchor("TOPLEFT", descWnd, "TOPRIGHT", 20, 0)
  listWnd:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  function parent:Init()
    local rewardInfos = X2EventCenter:GetAttendanceRewardInfos()
    table.sort(rewardInfos, function(lhs, rhs)
      return lhs.dayCount < rhs.dayCount and true or false
    end)
    local additionalRewardInfos = {}
    for i = 1, #rewardInfos do
      if rewardInfos[i].additionalReward ~= nil then
        table.insert(additionalRewardInfos, rewardInfos[i].additionalReward)
      end
    end
    table.sort(additionalRewardInfos, function(lhs, rhs)
      return lhs.dayCount < rhs.dayCount and true or false
    end)
    descWnd.additionalRewardWnd:SetRewardInfos(additionalRewardInfos)
    descWnd:CheckRewardState(rewardInfos.attendedArchelifeDayCount)
    listWnd:SetRewardInfos(rewardInfos)
    listWnd:CheckAttendable(rewardInfos)
  end
  UIParent:SetEventHandler("ACCOUNT_ATTENDANCE_LOADED", parent.Init)
  function parent:CheckRewardState()
    local attendedDayCount, attendedArchelifeDayCount = X2EventCenter:GetAttendedDayCount()
    descWnd:CheckRewardState(attendedArchelifeDayCount)
    listWnd:CheckRewardState(attendedDayCount)
  end
  UIParent:SetEventHandler("ACCOUNT_ATTENDANCE_ADDED", parent.CheckRewardState)
  parent:Init()
end
