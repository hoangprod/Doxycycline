local TEXTURE_INFO = {
  NORMAL = {
    PATH = "ui/battlefield/wave_normal.dds",
    KEY = "wave_normal"
  },
  BOSS = {
    PATH = "ui/battlefield/wave_boss.dds",
    KEY = "wave_boss"
  }
}
local function CreateIndunRoundStartMessage(id, parent)
  local wnd = UIParent:CreateWidget("window", id, parent)
  wnd:AddAnchor("TOP", "UIParent", 0, 53)
  wnd:EnableHidingIsRemove(true)
  wnd:SetUILayer("system")
  wnd:Clickable(false)
  local bg = wnd:CreateDrawable(TEXTURE_INFO.NORMAL.PATH, TEXTURE_INFO.NORMAL.KEY, "background")
  bg:AddAnchor("CENTER", wnd, 0, 0)
  wnd:SetExtent(bg:GetExtent())
  local number = wnd:CreateChildWidget("label", "title", 0, true)
  number:SetAutoResize(true)
  number:SetHeight(60)
  number.style:SetFont("combat", 60)
  local roundString = wnd:CreateChildWidget("label", "roundString", 0, true)
  roundString:SetAutoResize(true)
  roundString:SetHeight(FONT_SIZE.XXLARGE)
  roundString.style:SetFontSize(FONT_SIZE.XXLARGE)
  roundString.style:SetShadow(true)
  roundString:SetText(GetUIText(COMMON_TEXT, "round"))
  if baselibLocale.needChangeWordOrder then
    roundString:AddAnchor("RIGHT", number, "LEFT", -10, 0)
  else
    roundString:AddAnchor("LEFT", number, "RIGHT", 10, 0)
  end
  local elapsed = 0
  function wnd:OnUpdate(dt)
    elapsed = elapsed + dt
    if elapsed > 1000 then
      wnd:Show(false, 200)
      wnd:ReleaseHandler("OnUpdate")
      return
    end
  end
  function wnd:SetInfo(round, bossRound)
    number:SetText(tostring(round))
    number:RemoveAllAnchors()
    local x = baselibLocale.needChangeWordOrder and roundString:GetWidth() / 2 or -(roundString:GetWidth() / 2)
    local y = 0
    if bossRound then
      bg:SetTexture(TEXTURE_INFO.BOSS.PATH)
      bg:SetTextureInfo(TEXTURE_INFO.BOSS.KEY)
      y = 10
    else
      bg:SetTexture(TEXTURE_INFO.NORMAL.PATH)
      bg:SetTextureInfo(TEXTURE_INFO.NORMAL.KEY)
    end
    number:AddAnchor("CENTER", wnd, x, y)
    wnd:SetExtent(bg:GetExtent())
    elapsed = 0
    wnd:SetHandler("OnUpdate", wnd.OnUpdate)
  end
  return wnd
end
local roundStartMsg
function ShowIndunRoundStartMessage(round, bossRound)
  if roundStartMsg == nil then
    roundStartMsg = CreateIndunRoundStartMessage("indunRoundStartMessage", "UIParent")
    function roundStartMsg:OnHide()
      roundStartMsg = nil
    end
    roundStartMsg:SetHandler("OnHide", roundStartMsg.OnHide)
  end
  roundStartMsg:SetInfo(round, bossRound)
  roundStartMsg:Show(true, 200)
  roundStartMsg:Raise()
end
function ForceHideIndunRoundStartMessage()
  if roundStartMsg ~= nil and roundStartMsg:IsVisible() then
    roundStartMsg:Show(false)
  end
end
local roundEndMsg
local CreateRoundEndMessage = function(id, parent)
  local frame = CreateCenterMessageFrame(id, parent, "TYPE1")
  frame.iconBg:RemoveAllAnchors()
  frame.iconBg:AddAnchor("BOTTOM", frame.bg, "TOP", 0, MARGIN.WINDOW_SIDE)
  local title = frame:CreateChildWidget("textbox", "title", 0, true)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", frame.bg, 0, MARGIN.WINDOW_SIDE)
  title:SetExtent(frame:GetWidth(), FONT_SIZE.XLARGE)
  title.style:SetFontSize(FONT_SIZE.XLARGE)
  title.style:SetShadow(true)
  frame.body:SetWidth(1000)
  frame.body:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  frame.body:AddAnchor("TOP", title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 3)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  local elapsed = 0
  function frame:OnUpdate(dt)
    elapsed = elapsed + dt
    if elapsed > 5000 then
      frame:Show(false, 200)
      frame:ReleaseHandler("OnUpdate")
      return
    end
  end
  function frame:FillMsg(success, round, isBossRound, lastRound)
    local titleStr = ""
    local contentStr = ""
    local iconPath = ""
    local iconKey = ""
    if success then
      iconPath = "ui/tower_defense/win_bugle.dds"
      iconKey = "win_bugle"
      if lastRound then
        titleStr = GetUIText(COMMON_TEXT, "clear_indun_round_title")
        contentStr = GetUIText(COMMON_TEXT, "clear_indun_round_content")
      else
        titleStr = GetUIText(COMMON_TEXT, "success_indun_round", tostring(round))
        contentStr = isBossRound and GetUIText(COMMON_TEXT, "indun_next_round_boss") or ""
      end
    else
      iconPath = "ui/tower_defense/lose_flag.dds"
      iconKey = "lose_flag"
      titleStr = GetUIText(COMMON_TEXT, "fail_indun_round", tostring(round))
    end
    self.title:SetText(titleStr)
    self.icon:SetTexture(iconPath)
    self.icon:SetTextureInfo(iconKey)
    self.body:SetTextAutoWidth(1000, contentStr, 5)
    self.body:SetHeight(self.body:GetTextHeight())
    elapsed = 0
    self:SetHandler("OnUpdate", self.OnUpdate)
  end
  return frame
end
function ShowIndunRoundEndMessage(success, round, isBossRound, lastRound)
  if roundEndMsg == nil then
    roundEndMsg = CreateRoundEndMessage("indunRoundEndMessage", "UIParent")
    function roundEndMsg:OnHide()
      roundEndMsg = nil
    end
    roundEndMsg:SetHandler("OnHide", roundEndMsg.OnHide)
  end
  roundEndMsg:FillMsg(success, round, isBossRound, lastRound)
  roundEndMsg:Show(true, 200)
  roundEndMsg:Raise()
end
function ForceHideIndunRoundEndMessage()
  if roundEndMsg ~= nil and roundEndMsg:IsVisible() then
    roundEndMsg:Show(false)
  end
end
