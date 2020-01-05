function CreateSiegeSystemAlarm(id, parent)
  local STATUS_ICON_SIZE = {
    WIDTH = 198,
    HEIGHT = 132,
    TEXTURE_WIDTH = 153,
    TEXTURE_HEIGHT = 102
  }
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  window:SetExtent(0, 0)
  window:AddAnchor("TOP", "UIParent", 0, 60)
  window:Clickable(false)
  window:SetUILayer("system")
  local smallLayoutContent = window:CreateChildWidget("emptywidget", "smallLayoutContent", 0, true)
  smallLayoutContent:Show(false)
  smallLayoutContent:AddAnchor("TOP", window, 0, 80)
  smallLayoutContent:Clickable(false)
  local bg = CreateContentBackground(smallLayoutContent, "TYPE8", "black")
  bg:AddAnchor("TOPLEFT", smallLayoutContent, -MARGIN.WINDOW_SIDE, MARGIN.WINDOW_SIDE / 1.5)
  bg:AddAnchor("BOTTOMRIGHT", smallLayoutContent, 0, MARGIN.WINDOW_SIDE / 1.5)
  smallLayoutContent.bg = bg
  local periodIcon = smallLayoutContent:CreateDrawable(TEXTURE_PATH.SIEGE_PERIOD, "start", "overlay")
  periodIcon:SetExtent(STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
  periodIcon:AddAnchor("LEFT", smallLayoutContent, -13, -7)
  smallLayoutContent.periodIcon = periodIcon
  local statusText = smallLayoutContent:CreateChildWidget("textbox", "statusText", 0, true)
  statusText:AddAnchor("LEFT", smallLayoutContent, 75, 5)
  statusText:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  statusText:SetExtent(1000, 30)
  statusText.style:SetSnap(true)
  statusText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  statusText.style:SetAlign(ALIGN_CENTER)
  statusText.style:SetShadow(true)
  statusText:Clickable(false)
  local bigLayoutContent = window:CreateChildWidget("emptywidget", "bigLayoutContent", 0, true)
  bigLayoutContent:Show(false)
  bigLayoutContent:SetExtent(946, 190)
  bigLayoutContent:AddAnchor("TOP", window, 0, 0)
  bigLayoutContent:Clickable(false)
  local bg = bigLayoutContent:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "bg", "background")
  bg:AddAnchor("BOTTOM", bigLayoutContent, 0, 0)
  local statusBg = bigLayoutContent:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "icon_bg", "artwork")
  statusBg:AddAnchor("TOP", bigLayoutContent, 0, 0)
  bigLayoutContent.statusBg = statusBg
  local statusIcon = bigLayoutContent:CreateDrawable(TEXTURE_PATH.SIEGE_PERIOD, "start", "artwork")
  statusIcon:SetExtent(STATUS_ICON_SIZE.WIDTH, STATUS_ICON_SIZE.HEIGHT)
  statusIcon:AddAnchor("LEFT", statusBg, 10, -12)
  bigLayoutContent.statusIcon = statusIcon
  local statusTexture = bigLayoutContent:CreateDrawable(TEXTURE_PATH.SIEGE_PERIOD, "start", "overlay")
  statusTexture:AddAnchor("TOP", statusBg, "BOTTOM", 0, -(MARGIN.WINDOW_SIDE - 2))
  bigLayoutContent.statusTexture = statusTexture
  local statusText = bigLayoutContent:CreateChildWidget("textbox", "statusText", 0, true)
  statusText:AddAnchor("TOP", statusTexture, "BOTTOM", 0, 0)
  statusText:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  statusText.style:SetFontSize(FONT_SIZE.XLARGE)
  statusText.style:SetShadow(true)
  statusText.style:SetAlign(ALIGN_CENTER)
  statusText:Clickable(false)
  window.engravingName = nil
  local OnEndFadeOut = function(self)
    StartNextImgEvent()
  end
  window:SetHandler("OnEndFadeOut", OnEndFadeOut)
  local function BigLayoutDefaultSetting()
    window.bigLayoutContent.statusIcon:SetExtent(STATUS_ICON_SIZE.WIDTH, STATUS_ICON_SIZE.HEIGHT)
    window.bigLayoutContent.statusIcon:RemoveAllAnchors()
    window.bigLayoutContent.statusIcon:AddAnchor("LEFT", statusBg, 10, -12)
  end
  function window:SetInfo(period, str)
    if period ~= "siege_period_no_dominion" then
      self.bigLayoutContent.statusText:SetWidth(1000)
      self.bigLayoutContent.statusText:SetText(str)
    else
      return
    end
  end
  local function SetTextureBigLayout(coords)
    window.bigLayoutContent.statusTexture:SetCoords(coords[1], coords[2], coords[3], coords[4])
    window.bigLayoutContent.statusTexture:SetExtent(coords[3], coords[4])
  end
  local function SetResultIcon(isWin)
    if isWin then
      window.bigLayoutContent.statusIcon:SetTexture(TEXTURE_PATH.SIEGE_ENGRAVING_START)
      window.bigLayoutContent.statusIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
    else
      window.bigLayoutContent.statusIcon:SetTexture(TEXTURE_PATH.SIEGE_RESULT_ICON)
      window.bigLayoutContent.statusIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
    end
  end
  local function SetResultTexture(zoneGroupType)
    local path = TEXTURE_PATH.SIEGE_RESULT_TEXT
    local coords
    window.bigLayoutContent.statusTexture:SetTexture(TEXTURE_PATH.SIEGE_RESULT_TEXT)
    local winner = X2Dominion:IsSiegeWinnerMyFaction(zoneGroupType)
    if winner then
      SetResultIcon(true)
      coords = {
        GetTextureInfo(path, "sieg"):GetCoords()
      }
    else
      SetResultIcon(false)
      coords = {
        GetTextureInfo(path, "niederlage"):GetCoords()
      }
    end
    SetTextureBigLayout(coords)
  end
  local function SetWatchGameResultTexture(isDefense)
    local path = TEXTURE_PATH.SIEGE_RESULT_WATCH
    local coords
    window.bigLayoutContent.statusTexture:SetTexture(TEXTURE_PATH.SIEGE_RESULT_WATCH)
    if isDefense then
      SetResultIcon(true)
      coords = {
        GetTextureInfo(path, "defenders"):GetCoords()
      }
    else
      SetResultIcon(true)
      coords = {
        GetTextureInfo(path, "invaders"):GetCoords()
      }
    end
    SetTextureBigLayout(coords)
  end
  function window:SetFontColor(period, team, defenseWin)
    if period == "siege_period_declare" then
      ApplyTextColor(self.bigLayoutContent.statusText, FONT_COLOR.WHITE)
    elseif period == "siege_period_warmup" then
      ApplyTextColor(self.bigLayoutContent.statusText, FONT_COLOR.WHITE)
    elseif period == "siege_period_siege" then
      ApplyTextColor(self.bigLayoutContent.statusText, FONT_COLOR.WHITE)
    elseif period == "siege_period_peace" or period == "siege_period_auction" then
      ApplyTextColor(window.bigLayoutContent.statusText, FONT_COLOR.WHITE)
      if isMyInfo then
        local myTeamLose = false
        if defenseWin and team == "offense_team" then
          myTeamLose = true
        elseif defenseWin == false and team == "defense_team" then
          myTeamLose = true
        end
        if myTeamLose then
          ApplyTextColor(window.bigLayoutContent.statusText, FONT_COLOR.GRAY)
        end
      end
    else
      return
    end
  end
  function window:SetLayoutSiegeSchedule(period, action, onEvent, isMyInfo, defenseWin, zoneGroupType)
    self.bigLayoutContent:Show(false)
    self.smallLayoutContent:Show(false)
    local width = self.bigLayoutContent.statusText:GetLongestLineWidth()
    local height = self.bigLayoutContent.statusText:GetTextHeight()
    self.bigLayoutContent.statusText:SetExtent(width + 10, height)
    self.bigLayoutContent.statusIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
    BigLayoutDefaultSetting()
    local anchorX = 10
    if period == "siege_period_ready_to_siege" then
      if action == "change_state" then
        self.bigLayoutContent.statusIcon:SetTexture(TEXTURE_PATH.SIEGE_READY_TO_SIEGE)
        self.bigLayoutContent.statusTexture:SetTexture(TEXTURE_PATH.SIEGE_READY_TO_SIEGE)
        if onEvent then
          self.bigLayoutContent.statusTexture:SetTextureInfo("start")
        else
          self.bigLayoutContent.statusTexture:SetTextureInfo("progress")
        end
      elseif action == "declared_siege" then
        anchorX = 21
        self.bigLayoutContent.statusIcon:SetTexture(TEXTURE_PATH.SIEGE_DECLARE)
        self.bigLayoutContent.statusTexture:SetTexture(TEXTURE_PATH.SIEGE_DECLARE)
        self.bigLayoutContent.statusIcon:SetTextureInfo("image")
        self.bigLayoutContent.statusTexture:SetTextureInfo("declared")
      end
    elseif period == "siege_period_siege" then
      self.bigLayoutContent.statusIcon:SetTexture(TEXTURE_PATH.SIEGE_PERIOD)
      self.bigLayoutContent.statusTexture:SetTexture(TEXTURE_PATH.SIEGE_PERIOD)
      if onEvent then
        self.bigLayoutContent.statusTexture:SetTextureInfo("start")
      else
        self.bigLayoutContent.statusTexture:SetTextureInfo("progress")
      end
    elseif period == "siege_period_peace" then
      if isMyInfo then
        SetResultTexture(zoneGroupType)
      else
        SetWatchGameResultTexture(defenseWin)
      end
    else
      return
    end
    self.bigLayoutContent.statusIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
    self.bigLayoutContent.statusIcon:RemoveAllAnchors()
    self.bigLayoutContent.statusIcon:AddAnchor("LEFT", self.bigLayoutContent.statusBg, anchorX, -12)
    self.bigLayoutContent:Show(true)
  end
  function window:SetInfoGuardTower(msg)
    self.smallLayoutContent.statusText:SetWidth(1000)
    self.smallLayoutContent.statusText:SetText(msg)
  end
  function window:SetLayoutGuardTower()
    self.bigLayoutContent:Show(false)
    self.smallLayoutContent:Show(false)
    local width = self.smallLayoutContent.statusText:GetLongestLineWidth()
    local height = self.smallLayoutContent.statusText:GetTextHeight()
    self.smallLayoutContent:Show(true)
    self.smallLayoutContent:SetExtent(width + STATUS_ICON_SIZE.TEXTURE_WIDTH, height + MARGIN.WINDOW_SIDE * 2.5)
    ApplyTextColor(self.smallLayoutContent.statusText, FONT_COLOR.RED)
    self.smallLayoutContent.statusText:SetExtent(width + 10, height)
    self.smallLayoutContent.statusText:RemoveAllAnchors()
    self.smallLayoutContent.statusText:AddAnchor("LEFT", self.smallLayoutContent, 75, 15)
    self.smallLayoutContent.periodIcon:SetTexture(TEXTURE_PATH.SIEGE_GUARD_TOWER_ATTACK)
    self.smallLayoutContent.periodIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
  end
  function window:SetInfoEngraving(status, msg)
    if status == "siege_alert_engraving_started" or status == "siege_alert_engraving_stopped" then
      self.smallLayoutContent.statusText:SetWidth(1000)
      self.smallLayoutContent.statusText:SetText(msg)
    else
      return
    end
  end
  function window:SetLayoutEngraving(status)
    self.bigLayoutContent:Show(false)
    self.smallLayoutContent:Show(false)
    if status == "siege_alert_engraving_started" or status == "siege_alert_engraving_stopped" then
      local width = self.smallLayoutContent.statusText:GetLongestLineWidth()
      local height = self.smallLayoutContent.statusText:GetTextHeight()
      if status == "siege_alert_engraving_started" then
        ApplyTextColor(self.smallLayoutContent.statusText, FONT_COLOR.SKYBLUE)
        self.smallLayoutContent.periodIcon:SetTexture(TEXTURE_PATH.SIEGE_ENGRAVING_START)
        self.smallLayoutContent.periodIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
      elseif status == "siege_alert_engraving_stopped" then
        ApplyTextColor(self.smallLayoutContent.statusText, F_COLOR.GetColor("original_light_gray", false))
        self.smallLayoutContent.periodIcon:SetTexture(TEXTURE_PATH.SIEGE_RESULT_ICON)
        self.smallLayoutContent.periodIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
      else
        return
      end
      self.smallLayoutContent:Show(true)
      self.smallLayoutContent:SetExtent(width + STATUS_ICON_SIZE.TEXTURE_WIDTH, height + MARGIN.WINDOW_SIDE * 2.5)
      self.smallLayoutContent.statusText:SetExtent(width + 10, height)
      self.smallLayoutContent.statusText:RemoveAllAnchors()
      self.smallLayoutContent.statusText:AddAnchor("LEFT", self.smallLayoutContent, 75, 15)
    end
  end
  function window:SetInfoReinforcement(msg)
    self.smallLayoutContent.statusText:SetWidth(1000)
    self.smallLayoutContent.statusText:SetText(msg)
  end
  function window:SetLayoutReinforcement()
    self.bigLayoutContent:Show(false)
    self.smallLayoutContent:Show(false)
    local width = self.smallLayoutContent.statusText:GetLongestLineWidth()
    local height = self.smallLayoutContent.statusText:GetTextHeight()
    ApplyTextColor(self.smallLayoutContent.statusText, FONT_COLOR.WHITE)
    self.smallLayoutContent.periodIcon:SetTexture(TEXTURE_PATH.SIEGE_REINFORCEMENT)
    self.smallLayoutContent.periodIcon:SetCoords(0, 0, STATUS_ICON_SIZE.TEXTURE_WIDTH, STATUS_ICON_SIZE.TEXTURE_HEIGHT)
    self.smallLayoutContent:Show(true)
    self.smallLayoutContent:SetExtent(width + STATUS_ICON_SIZE.TEXTURE_WIDTH, height + MARGIN.WINDOW_SIDE * 2.5)
    self.smallLayoutContent.statusText:SetExtent(width + 10, height)
    self.smallLayoutContent.statusText:RemoveAllAnchors()
    self.smallLayoutContent.statusText:AddAnchor("LEFT", self.smallLayoutContent, 75, 15)
  end
  function window:SetInfoDeclareTerritor(msg)
    ApplyTextColor(self.bigLayoutContent.statusText, FONT_COLOR.WHITE)
    self.bigLayoutContent.statusText:SetWidth(1000)
    self.bigLayoutContent.statusText:SetText(msg)
  end
  function window:SetLayoutDeclareTerritory()
    self.bigLayoutContent:Show(false)
    self.smallLayoutContent:Show(false)
    self.bigLayoutContent:Show(true)
    local width = self.bigLayoutContent.statusText:GetLongestLineWidth()
    local height = self.bigLayoutContent.statusText:GetTextHeight()
    self.bigLayoutContent.statusText:SetExtent(width + 10, height)
    self.bigLayoutContent.statusIcon:SetTexture(TEXTURE_PATH.SIEGE_DECLARE_TERRITORY)
    self.bigLayoutContent.statusIcon:SetCoords(0, 0, 73, 88)
    self.bigLayoutContent.statusIcon:SetExtent(73, 88)
    self.bigLayoutContent.statusIcon:RemoveAllAnchors()
    self.bigLayoutContent.statusIcon:AddAnchor("CENTER", self.bigLayoutContent.statusBg, 0, -5)
    self.bigLayoutContent.statusTexture:SetTexture(TEXTURE_PATH.SIEGE_DECLARE_TERRITORY)
    SetTextureBigLayout({
      GetTextureInfo(TEXTURE_PATH.SIEGE_DECLARE_TERRITORY, "territory"):GetCoords()
    })
  end
  return window
end
siegeSystemAlarmWindow = CreateSiegeSystemAlarm("siegeSystemAlarmWindow", systemLayerParent)
