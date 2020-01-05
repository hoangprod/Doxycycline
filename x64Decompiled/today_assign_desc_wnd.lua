W_TODAY_ASSIGN_DESC = {}
W_TODAY_ASSIGN_DESC.TYPE = {
  HERO = 1,
  FAMILY = 2,
  EXPEDITION = 3,
  TODAY = 4,
  ARCHE_PASS = 5
}
local infos = {
  [W_TODAY_ASSIGN_DESC.TYPE.HERO] = {
    image = {
      path = TEXTURE_PATH.HERO_QUEST_IMAGE,
      key = "hero"
    },
    title = GetCommonText("hero"),
    desc = GetCommonText("hero_quest_explain")
  },
  [W_TODAY_ASSIGN_DESC.TYPE.FAMILY] = {
    image = {
      path = TEXTURE_PATH.FAMILY_HAPPY_LIFE,
      key = "image"
    },
    title = GetCommonText("family_happy_life"),
    desc = GetCommonText("family_happy_life_content")
  },
  [W_TODAY_ASSIGN_DESC.TYPE.EXPEDITION] = {
    image = {
      path = TEXTURE_PATH.EXPEDITION_MISSION,
      key = "bg"
    },
    title = GetCommonText("expedition_today_quest"),
    desc = GetCommonText("expedition_today_quest_notice")
  },
  [W_TODAY_ASSIGN_DESC.TYPE.TODAY] = {
    image = {
      path = TEXTURE_PATH.EVENT_CENTER_COMMON,
      key = "image"
    },
    title = GetCommonText("today_assignment"),
    desc = GetCommonText("today_assign_update")
  }
}
function CreateTodayAssignDescWnd(id, parent, type)
  local info = infos[type]
  if info == nil then
    return
  end
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local leftBg = wnd:CreateDrawable(info.image.path, info.image.key, "background")
  leftBg:AddAnchor("TOPLEFT", wnd, 0, 0)
  local WINDOW_WIDTH = leftBg:GetWidth()
  local WINDOW_HEIGHT = leftBg:GetHeight()
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.XLARGE)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  title:SetText(info.title)
  title:AddAnchor("TOP", wnd, 0, 40)
  local desc = wnd:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetAutoResize(true)
  desc:SetWidth(WINDOW_WIDTH)
  desc.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(desc, FONT_COLOR.BROWN)
  desc:SetText(info.desc)
  desc:SetWidth(desc:GetLongestLineWidth() + 4)
  desc:AddAnchor("TOP", wnd, 0, 80)
  wnd:SetExtent(WINDOW_WIDTH, WINDOW_HEIGHT)
  return wnd
end
