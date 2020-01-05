local frameInfo = {
  width = 250,
  height = 226,
  bgHeight = 35,
  roundInfoHeight = 30,
  objectInfoHeight = 50,
  resourceConditionHeight = 41,
  resourceIconPath = "ui/icon/icon_item_4707.dds"
}
local function CreateDefenceInfo(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:SetExtent(frameInfo.width, frameInfo.height)
  frame:AddAnchor("TOPRIGHT", "UIParent", -265, 0)
  local baseBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  baseBg:SetTextureInfo("team_bg", "alpha60")
  baseBg:AddAnchor("TOPLEFT", frame, 0, 0)
  baseBg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local roundInfoBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  roundInfoBg:SetTextureInfo("team_bg", "status_alpha_35")
  roundInfoBg:AddAnchor("TOPLEFT", frame, 0, 0)
  local topPos = 0
  local bottomPos = frameInfo.bgHeight - frameInfo.height
  roundInfoBg:AddAnchor("BOTTOMRIGHT", frame, 0, bottomPos)
  frame.roundLabel = frame:CreateChildWidget("label", "roundLabel", 0, true)
  frame.roundLabel:AddAnchor("TOPLEFT", frame, 15, topPos)
  frame.roundLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos)
  frame.roundLabel:SetAutoResize(true)
  frame.roundLabel:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(frame.roundLabel, FONT_COLOR.SOFT_YELLOW)
  frame.roundLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_round_title"))
  topPos = topPos + frameInfo.bgHeight
  bottomPos = bottomPos + frameInfo.roundInfoHeight
  frame.roundInfoLabel = frame:CreateChildWidget("label", "roundInfoLabel", 0, true)
  frame.roundInfoLabel:AddAnchor("TOPLEFT", frame, 15, topPos)
  frame.roundInfoLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos)
  frame.roundInfoLabel:SetAutoResize(true)
  frame.roundInfoLabel:SetHeight(FONT_SIZE.LARGE)
  ApplyTextColor(frame.roundInfoLabel, FONT_COLOR.WHITE)
  frame.roundInfoLabel:SetText(string.format(GetUIText(COMMON_TEXT, "defence_of_feast_round_body", "0", "0")))
  topPos = topPos + frameInfo.roundInfoHeight
  local objectInfoBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  objectInfoBg:SetTextureInfo("team_bg", "status_alpha_35")
  bottomPos = bottomPos + frameInfo.bgHeight
  objectInfoBg:AddAnchor("TOPLEFT", frame, 0, topPos)
  objectInfoBg:AddAnchor("BOTTOMRIGHT", frame, 0, bottomPos)
  frame.objectLabel = frame:CreateChildWidget("label", "objectLabel", 0, true)
  frame.objectLabel:AddAnchor("TOPLEFT", frame, 15, topPos)
  frame.objectLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos)
  frame.objectLabel:SetAutoResize(true)
  frame.objectLabel:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(frame.objectLabel, FONT_COLOR.SOFT_YELLOW)
  frame.objectLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_object_title"))
  topPos = topPos + frameInfo.bgHeight
  bottomPos = bottomPos + frameInfo.objectInfoHeight
  frame.objectKindLabel = frame:CreateChildWidget("label", "objectKindLabel", 0, true)
  frame.objectKindLabel:AddAnchor("TOPLEFT", frame, 15, topPos)
  frame.objectKindLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos - 30)
  frame.objectKindLabel:SetAutoResize(true)
  frame.objectKindLabel:SetHeight(FONT_SIZE.LARGE)
  ApplyTextColor(frame.objectKindLabel, FONT_COLOR.WHITE)
  frame.objectKindLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_object_name"))
  local cunstomInfo = {
    path = TEXTURE_PATH.SIEGE_HP_BAR,
    textureKey = "siege_gauge",
    coords = {
      GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetCoords()
    }
  }
  local hpBar = W_BAR.CreateCustomHpBar(id .. ".hpBar", frame, cunstomInfo)
  hpBar:SetExtent(217, 18)
  hpBar:ReleaseHandler("OnLeave")
  hpBar:ReleaseHandler("OnEnter")
  hpBar:AddAnchor("BOTTOM", frame.objectKindLabel, "BOTTOM", 0, 20)
  local colors = GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetColors().siege_red
  hpBar:ChangeStatusBarColor(colors)
  local bgColors = GetTextureInfo(TEXTURE_PATH.HUD, "siege_gauge_bg"):GetColors().default
  hpBar:ChangeStatusBarBgColor(bgColors)
  frame.hpBar = hpBar
  local hpText = frame:CreateChildWidget("label", "hpText", 0, true)
  hpText:AddAnchor("TOPLEFT", hpBar, 0, 0)
  hpText:AddAnchor("BOTTOMRIGHT", hpBar, 0, -1)
  hpText.style:SetFontSize(FONT_SIZE.SMALL)
  hpText.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(hpText, FONT_COLOR.WHITE)
  hpText.style:SetShadow(true)
  frame.hpText = hpText
  topPos = topPos + frameInfo.objectInfoHeight
  local resourceConditionBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  resourceConditionBg:SetTextureInfo("team_bg", "status_alpha_35")
  bottomPos = bottomPos + frameInfo.bgHeight
  resourceConditionBg:AddAnchor("TOPLEFT", frame, 0, topPos)
  resourceConditionBg:AddAnchor("BOTTOMRIGHT", frame, 0, bottomPos)
  frame.resourceConditionLabel = frame:CreateChildWidget("label", "resourceConditionLabel", 0, true)
  frame.resourceConditionLabel:AddAnchor("TOPLEFT", frame, 15, topPos)
  frame.resourceConditionLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos)
  frame.resourceConditionLabel:SetAutoResize(true)
  frame.resourceConditionLabel:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(frame.resourceConditionLabel, FONT_COLOR.SOFT_YELLOW)
  frame.resourceConditionLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_resource_title"))
  topPos = topPos + frameInfo.bgHeight
  bottomPos = bottomPos + frameInfo.resourceConditionHeight
  frame.resourceKindLabel = frame:CreateChildWidget("label", "resourceKindLabel", 0, true)
  frame.resourceKindLabel:AddAnchor("TOPLEFT", frame, 41, topPos)
  frame.resourceKindLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos)
  frame.resourceKindLabel:SetAutoResize(true)
  frame.resourceKindLabel:SetHeight(FONT_SIZE.LARGE)
  frame.resourceKindLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(frame.resourceKindLabel, FONT_COLOR.WHITE)
  frame.resourceKindLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_resource_body"))
  local icon = frame:CreateIconImageDrawable(frameInfo.resourceIconPath, "overlay")
  icon:SetExtent(28, 28)
  icon:SetColor(1, 1, 1, 1)
  icon:AddAnchor("LEFT", frame.resourceKindLabel, -33, 0)
  icon:SetVisible(true)
  frame.resourceIcon = icon
  frame.resourceInfoLabel = frame:CreateChildWidget("label", "resourceInfoLabel", 0, true)
  frame.resourceInfoLabel:AddAnchor("TOPLEFT", frame, 41, topPos)
  frame.resourceInfoLabel:AddAnchor("BOTTOMRIGHT", frame, -15, bottomPos)
  frame.resourceInfoLabel:SetAutoResize(true)
  frame.resourceInfoLabel:SetHeight(FONT_SIZE.LARGE)
  frame.resourceInfoLabel.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(frame.resourceInfoLabel, FONT_COLOR.WHITE)
  frame.resourceInfoLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_resource_count", "0"))
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
  function frame:UpdateRound()
    local info = X2Indun:GetRoundInfo()
    if info == nil then
      return
    end
    local curRound = tostring(info.currentRound)
    local totalRound = tostring(info.totalRound)
    self.roundInfoLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_round_body", curRound, totalRound))
  end
  function frame:Set(info)
    if info.iconPath ~= nil and info.iconPath ~= frameInfo.resourceIconPath then
      frameInfo.resourceIconPath = info.iconPath
      local icon = frame:CreateIconImageDrawable(frameInfo.resourceIconPath, "overlay")
      icon:SetExtent(28, 28)
      icon:SetCoords(0, 0, 28, 28)
      icon:SetColor(1, 1, 1, 1)
      icon:AddAnchor("LEFT", frame.resourceKindLabel, -33, 0)
      icon:SetVisible(true)
      self.resourceIcon = icon
    end
    if info.resource ~= nil then
      local count = info.resource
      frame.resourceInfoLabel:SetText(GetUIText(COMMON_TEXT, "defence_of_feast_resource_count", tostring(count)))
    end
    if info.objectName ~= nil then
      frame.objectKindLabel:SetText(info.objectName)
    end
  end
  function frame:SetHp(curHealth, maxHealth)
    self.hpBar:SetMinMaxValues(0, maxHealth)
    self.hpBar:SetValue(curHealth)
    local percent = maxHealth > 0 and math.floor(curHealth * 100 / maxHealth) or 0
    local text = string.format("%d/%d(%d%%)", curHealth, maxHealth, percent)
    self.hpText:SetText(text)
  end
  local events = {
    LEFT_LOADING = function()
      frame:Show(false)
    end,
    UPDATE_DEFENCE_INFO = function(info)
      if not frame:IsVisible() then
        frame:Show(true)
        frame:UpdateRound()
      end
      frame:Set(info)
    end,
    TARGET_NPC_HEALTH_CHANGED_FOR_DEFENCE_INFO = function(curHp, maxHp)
      if not frame:IsVisible() then
        frame:Show(true)
        frame:UpdateRound()
      end
      frame:SetHp(curHp, maxHp)
    end,
    INDUN_INITAL_ROUND_INFO = function()
      frame:UpdateRound()
    end,
    INDUN_UPDATE_ROUND_INFO = function()
      frame:UpdateRound()
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
local DefenceInfoFrame = CreateDefenceInfo("defenceInfo", "UIParent")
