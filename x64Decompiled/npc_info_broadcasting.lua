local ScoreBoardAnchorByIndex = {
  {
    15,
    0,
    -15,
    -110
  },
  {
    52,
    40,
    -15,
    -73
  },
  {
    52,
    103,
    -178,
    -10
  },
  {
    134,
    103,
    -96,
    -10
  },
  {
    215,
    103,
    -15,
    -10
  }
}
local IconAnchorByIndex = {
  {0, 0},
  {15, 39},
  {15, 102},
  {97, 102},
  {178, 102}
}
local function CreateScoreBoardLabel(frame, index, align, withCount, countAlign)
  local label = frame:CreateChildWidget("label", "label", index, true)
  label:AddAnchor("TOPLEFT", frame, ScoreBoardAnchorByIndex[index][1], ScoreBoardAnchorByIndex[index][2])
  label:AddAnchor("BOTTOMRIGHT", frame, ScoreBoardAnchorByIndex[index][3], ScoreBoardAnchorByIndex[index][4])
  label:SetAutoResize(true)
  label:SetHeight(FONT_SIZE.MIDDLE)
  label.style:SetAlign(align)
  if withCount ~= nil and withCount == true then
    local count = frame:CreateChildWidget("label", "count", 0, true)
    count:AddAnchor("TOPLEFT", frame, ScoreBoardAnchorByIndex[index][1] + 163, ScoreBoardAnchorByIndex[index][2])
    count:AddAnchor("BOTTOMRIGHT", frame, ScoreBoardAnchorByIndex[index][3], ScoreBoardAnchorByIndex[index][4])
    count:SetAutoResize(true)
    count:SetHeight(FONT_SIZE.MIDDLE)
    count.style:SetAlign(countAlign)
    label.count = count
  end
  return label
end
local function SetScoreBoardIcon(frame, index, iconPath)
  if iconPath == nil then
    return
  end
  local icon = frame:CreateIconImageDrawable(iconPath, "overlay")
  icon:SetExtent(28, 28)
  icon:SetCoords(0, 0, 28, 28)
  icon:SetColor(1, 1, 1, 1)
  icon:AddAnchor("TOPLEFT", frame, IconAnchorByIndex[index][1], IconAnchorByIndex[index][2])
  icon:SetVisible(true)
  frame.label[index].icon = icon
end
local function CreateNpcInfoBroadcasting(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:SetExtent(250, 141)
  frame:AddAnchor("TOPRIGHT", "UIParent", -265, 0)
  local bg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureInfo("team_bg", "alpha60")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local timerBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  timerBg:SetTextureInfo("team_bg", "status_alpha_35")
  timerBg:AddAnchor("TOPLEFT", frame, 0, 0)
  timerBg:AddAnchor("BOTTOMRIGHT", frame, 0, -106)
  local titleBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  titleBg:SetTextureInfo("team_bg", "status_alpha_35")
  titleBg:AddAnchor("TOPLEFT", frame, 0, 73)
  titleBg:AddAnchor("BOTTOMRIGHT", frame, 0, -43)
  frame.label = {}
  frame.suppliesLabel = frame:CreateChildWidget("label", "label", 0, true)
  frame.suppliesLabel:AddAnchor("TOPLEFT", frame, 15, 72)
  frame.suppliesLabel:AddAnchor("BOTTOMRIGHT", frame, -15, -44)
  frame.suppliesLabel:SetAutoResize(true)
  frame.suppliesLabel:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(frame.suppliesLabel, FONT_COLOR.SOFT_YELLOW)
  frame.suppliesLabel:SetText(GetUIText(COMMON_TEXT, "supplies_condition"))
  frame.label[1] = CreateScoreBoardLabel(frame, 1, ALIGN_CENTER)
  frame.label[1].style:SetFontSize(FONT_SIZE.XLARGE)
  frame.label[1]:SetHeight(FONT_SIZE.XLARGE)
  ApplyTextColor(frame.label[1], FONT_COLOR.BATTLEFIELD_TIME)
  frame.label[2] = CreateScoreBoardLabel(frame, 2, ALIGN_LEFT, true, ALIGN_CENTER)
  frame.label[2]:SetAutoResize(true)
  frame.label[2].buffType = HIRAMAKAND_SAVE_PEOPLE_BUFF_TYPE
  frame.label[3] = CreateScoreBoardLabel(frame, 3, ALIGN_CENTER)
  frame.label[4] = CreateScoreBoardLabel(frame, 4, ALIGN_CENTER)
  frame.label[5] = CreateScoreBoardLabel(frame, 5, ALIGN_CENTER)
  local dragWindow = frame:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", frame, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  dragWindow:EnableDrag(true)
  local function OnDragStart(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    frame:StartMoving()
    self.moving = true
  end
  dragWindow:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop(self)
    if self.moving == true then
      frame:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  dragWindow:SetHandler("OnDragStop", OnDragStop)
  function frame:Set(info)
    local function FindLabelIndexByBuffType(info)
      for i = 1, #self.label do
        if self.label[i].buffType ~= nil and self.label[i].buffType == info.buffType then
          return i
        end
      end
      if info.stack == nil then
        self.label[1].buffType = info.buffType
        return 1
      else
        for i = 3, #self.label do
          if self.label[i].buffType == nil then
            self.label[i].buffType = info.buffType
            return i
          end
        end
      end
    end
    for i, v in ipairs(info) do
      local index = FindLabelIndexByBuffType(v)
      if v.stack == nil then
        local hour, minute, second = GetHourMinuteSecondeFromSec(v.leftTime / 1000)
        local timeStr = string.format("%02d : %02d : %02d", hour, minute, second)
        frame.label[index]:SetText(timeStr)
      elseif index == 2 then
        frame.label[index]:SetText(tostring(v.buffName))
        frame.label[index].count:SetText(tostring(v.stack))
        if frame.label[index].icon == nil then
          SetScoreBoardIcon(frame, index, v.iconPath)
        end
      else
        frame.label[index]:SetText(tostring(v.stack))
        if frame.label[index].icon == nil then
          SetScoreBoardIcon(frame, index, v.iconPath)
        end
      end
    end
  end
  local events = {
    LEFT_LOADING = function()
      frame:Show(false)
    end,
    UPDATE_NPC_INFO_BROADCASTING = function(info)
      if not frame:IsVisible() then
        frame:Show(true)
      end
      frame:Set(info)
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
local frame = CreateNpcInfoBroadcasting("npcInfoBroadcasting", "UIParent")
