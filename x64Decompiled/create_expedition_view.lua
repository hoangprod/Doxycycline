local EXPEDITION_WIDTH = 510
local EXPEDITION_HEIGHT = 380
local EXPEDITION_OUTLAW_HEIGHT = 320
local EXPEDITION_USER_ALLIANCE_HEIGHT = 120
local SPONSOR_ICON_PATH = "ui/faction.dds"
local factionBtnHeight = 52
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
expedition = {}
expedition = CreateWindow("expedition", "UIParent")
expedition:Show(false)
expedition:AddAnchor("CENTER", "UIParent", 0, 0)
expedition:SetExtent(EXPEDITION_WIDTH, EXPEDITION_HEIGHT)
expedition:SetTitle(locale.expedition.title)
local inset = 20
local cmd = expedition:CreateChildWidget("window", "cmd", 0, true)
cmd:Show(true)
cmd:AddAnchor("TOPLEFT", expedition, sideMargin, titleMargin)
cmd:AddAnchor("BOTTOMRIGHT", expedition, -sideMargin, -sideMargin)
local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_FACTION)
local expeditionName = W_CTRL.CreateEdit("expeditionName", cmd)
expeditionName:SetExtent(372, DEFAULT_SIZE.EDIT_HEIGHT)
expeditionName:SetMaxTextLength(namePolicyInfo.max)
expeditionName:AddAnchor("BOTTOMLEFT", cmd, 2, 0)
local inputNameLabel = cmd:CreateChildWidget("label", "inputNameLabel", 0, true)
inputNameLabel:SetAutoResize(true)
inputNameLabel:SetHeight(FONT_SIZE.MIDDLE)
inputNameLabel:AddAnchor("BOTTOMLEFT", expeditionName, "TOPLEFT", 0, expeditionLocale.intputNameLabel.anchorHeight)
inputNameLabel:SetText(locale.expedition.inputNameGuide)
ApplyTextColor(inputNameLabel, FONT_COLOR.DEFAULT)
local guide = inputNameLabel:CreateChildWidget("textbox", "guide", 0, true)
guide:SetExtent(cmd:GetWidth(), FONT_SIZE.SMALL)
guide:AddAnchor("TOPLEFT", inputNameLabel, "BOTTOMLEFT", 0, 2)
guide:SetAutoResize(true)
guide:SetText(F_TEXT.GetLimitInfoText(namePolicyInfo))
guide.style:SetFontSize(FONT_SIZE.SMALL)
guide.style:SetAlign(ALIGN_LEFT)
ApplyTextColor(guide, FONT_COLOR.GRAY)
local confirm = cmd:CreateChildWidget("button", "confirm", 0, true)
confirm:Show(true)
confirm:Enable(false)
confirm:SetText(locale.expedition.confirm)
confirm:AddAnchor("LEFT", expeditionName, "RIGHT", 5, 0)
ApplyButtonSkin(confirm, BUTTON_BASIC.DEFAULT)
local selectSponsor = expedition:CreateChildWidget("window", "selectSponsor", 0, true)
selectSponsor:Show(true)
selectSponsor:SetExtent(470, 250)
selectSponsor:AddAnchor("TOP", cmd, 0, 0)
selectSponsor:SetTitleText(locale.expedition.notice)
selectSponsor.titleStyle:SetAlign(ALIGN_TOP)
selectSponsor.titleStyle:SetColor(FONT_COLOR.TITLE[1], FONT_COLOR.TITLE[2], FONT_COLOR.TITLE[3], 1)
selectSponsor.titleStyle:SetFont(FONT_PATH.DEFAULT, expeditionLocale.titleFontSize)
local bg = CreateContentBackground(selectSponsor, "TYPE6", "brown")
bg:SetExtent(480, 65)
bg:AddAnchor("TOP", selectSponsor, 10, sideMargin * 1.3)
local tab = selectSponsor:CreateChildWidget("tab", "tab", 0, true)
tab:SetGap(10)
tab:AddAnchor("TOPLEFT", selectSponsor, 0, sideMargin * 1.5)
tab:AddAnchor("BOTTOMRIGHT", selectSponsor, 0, 0)
tab:SetCorner("TOPLEFT")
tab:SelectTab(1)
local max_tab_count = 7
for i = 1, max_tab_count do
  tab:AddSimpleTab("")
end
for i = 1, #tab.window do
  tab.selectedButton[i]:SetExtent(48, 48)
  tab.unselectedButton[i]:SetExtent(48, 48)
  local selected_bg = tab.selectedButton[i]:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
  selected_bg:AddAnchor("TOPLEFT", tab.selectedButton[i], -1, -1)
  selected_bg:AddAnchor("BOTTOMRIGHT", tab.selectedButton[i], 1, 1)
  local unSelected_bg = tab.unselectedButton[i]:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
  unSelected_bg:AddAnchor("TOPLEFT", tab.unselectedButton[i], -1, -1)
  unSelected_bg:AddAnchor("BOTTOMRIGHT", tab.unselectedButton[i], 1, 1)
end
for i = 1, #tab.window do
  local btn = tab.selectedButton[i]
  btn.icon = btn:CreateDrawable(SPONSOR_ICON_PATH, "nuia_sponsor_1", "background")
  btn.icon:SetExtent(48, 48)
  btn.icon:AddAnchor("CENTER", btn, 0, 0)
  btn = tab.unselectedButton[i]
  btn.icon = btn:CreateDrawable(SPONSOR_ICON_PATH, "nuia_sponsor_1", "background")
  btn.icon:SetExtent(48, 48)
  btn.icon:AddAnchor("CENTER", btn, 0, 0)
  local offsetY = 30
  local wnd = tab.window[i]
  local icon = tab.window[i]:CreateDrawable(SPONSOR_ICON_PATH, "nuia_sponsor_1", "overlay")
  icon:SetExtent(128, 128)
  icon:AddAnchor("TOPLEFT", tab.window[i], 5, sideMargin * 1.5)
  tab.window[i].icon = icon
  local icon_bg = tab.window[i]:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
  icon_bg:AddAnchor("TOPLEFT", icon, -1, -1)
  icon_bg:AddAnchor("BOTTOMRIGHT", icon, 1, 1)
  local sponsorLabel = tab.window[i]:CreateChildWidget("label", "sponsorName", 0, true)
  sponsorLabel:SetHeight(20)
  sponsorLabel:SetAutoResize(true)
  sponsorLabel:AddAnchor("TOPLEFT", icon_bg, "TOPRIGHT", sideMargin / 2, 0)
  ApplyTextColor(sponsorLabel, FONT_COLOR.TITLE)
  sponsorLabel.style:SetAlign(ALIGN_LEFT)
  sponsorLabel.style:SetFontSize(FONT_SIZE.LARGE)
  local sponsorExplanation = tab.window[i]:CreateChildWidget("textbox", "sponsorExplanation", 0, true)
  sponsorExplanation:Show(true)
  sponsorExplanation:SetExtent(325, 120)
  sponsorExplanation:AddAnchor("TOPLEFT", sponsorLabel, "BOTTOMLEFT", 0, 5)
  sponsorExplanation:SetInset(0, 0, 20, 0)
  ApplyTextColor(sponsorExplanation, FONT_COLOR.DEFAULT)
  sponsorExplanation.style:SetSnap(true)
  sponsorExplanation.style:SetAlign(ALIGN_TOP_LEFT)
end
local outlaw = expedition:CreateChildWidget("emptywidget", "outlaw", 0, true)
outlaw:Show(true)
outlaw:AddAnchor("TOPLEFT", cmd, 0, 0)
outlaw:AddAnchor("BOTTOMRIGHT", cmd, 0, -sideMargin * 1.5)
local icon_bg = outlaw:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
icon_bg:SetExtent(130, 130)
icon_bg:AddAnchor("LEFT", outlaw, 0, 0)
local icon = outlaw:CreateDrawable(SPONSOR_ICON_PATH, "outlaw", "overlay")
icon:AddAnchor("CENTER", icon_bg, 0, 0)
expedition.outlaw.icon = icon
local sponsorName = outlaw:CreateChildWidget("label", "sponsorName", 0, true)
sponsorName:SetHeight(20)
sponsorName:SetAutoResize(true)
sponsorName:AddAnchor("TOPLEFT", icon_bg, "TOPRIGHT", sideMargin / 2, 0)
ApplyTextColor(sponsorName, FONT_COLOR.RED)
sponsorName.style:SetAlign(ALIGN_LEFT)
sponsorName.style:SetFontSize(FONT_SIZE.LARGE)
local sponsorExplanation = outlaw:CreateChildWidget("textbox", "sponsorExplanation", 0, true)
sponsorExplanation:Show(true)
sponsorExplanation:AddAnchor("TOPLEFT", sponsorName, "BOTTOMLEFT", 0, 5)
sponsorExplanation:AddAnchor("BOTTOMRIGHT", outlaw, 0, -sideMargin * 2)
sponsorExplanation:SetInset(0, 0, 20, 0)
ApplyTextColor(sponsorExplanation, FONT_COLOR.DEFAULT)
sponsorExplanation.style:SetSnap(true)
sponsorExplanation.style:SetAlign(ALIGN_TOP_LEFT)
function expedition:FillAllianceInfo(alliance)
  local GetOutLawInfo = function()
    local names = locale.expedition.outlaw_name
    local descs = locale.expedition.outlaw_desc
    local info = {
      id = 161,
      name = names[1],
      desc = descs[1],
      key = "outlaw"
    }
    return info
  end
  local GetNuiaAllianceInfo = function()
    local names = locale.expedition.nuia_alliance_name
    local descs = locale.expedition.nuia_alliance_desc
    local info = {
      {
        id = 101,
        name = names[1],
        desc = descs[1],
        key = "nuia_sponsor_1"
      },
      {
        id = 102,
        name = names[2],
        desc = descs[2],
        key = "nuia_sponsor_2"
      },
      {
        id = 103,
        name = names[3],
        desc = descs[3],
        key = "nuia_sponsor_3"
      },
      {
        id = 105,
        name = names[5],
        desc = descs[5],
        key = "nuia_sponsor_5"
      },
      {
        id = 106,
        name = names[6],
        desc = descs[6],
        key = "nuia_sponsor_6"
      },
      {
        id = 107,
        name = names[7],
        desc = descs[7],
        key = "nuia_sponsor_7"
      },
      {
        id = 104,
        name = names[4],
        desc = descs[4],
        key = "nuia_sponsor_4"
      }
    }
    return info, 36
  end
  local GetHariharaAllianceInfo = function()
    local names = locale.expedition.harihara_alliance_name
    local descs = locale.expedition.harihara_alliance_desc
    local info = {
      {
        id = 108,
        name = names[1],
        desc = descs[1],
        key = "harihara_sponsor_1"
      },
      {
        id = 109,
        name = names[2],
        desc = descs[2],
        key = "harihara_sponsor_2"
      },
      {
        id = 110,
        name = names[3],
        desc = descs[3],
        key = "harihara_sponsor_3"
      },
      {
        id = 111,
        name = names[4],
        desc = descs[4],
        key = "harihara_sponsor_4"
      },
      {
        id = 113,
        name = names[6],
        desc = descs[6],
        key = "harihara_sponsor_6"
      },
      {
        id = 187,
        name = names[5],
        desc = descs[5],
        key = "harihara_sponsor_5"
      }
    }
    return info, 66
  end
  local InitSponsorsTab = function(info, offset)
    local tab = expedition.selectSponsor.tab
    tab:SetOffset(offset)
    tab:SetActivateTabCount(#info)
    function SetSponsorButtonIcon(icon, key, extent)
      icon:SetTextureInfo(key)
      icon:SetExtent(extent, extent)
    end
    for i = 1, #info do
      SetSponsorButtonIcon(tab.selectedButton[i].icon, info[i].key, 48)
      SetSponsorButtonIcon(tab.unselectedButton[i].icon, info[i].key, 48)
      tab.window[i].allianceId = info[i].id
      tab.window[i].sponsorName:SetText(info[i].name)
      tab.window[i].sponsorExplanation:SetText(info[i].desc)
      SetSponsorButtonIcon(tab.window[i].icon, info[i].key, 128)
    end
    tab:SelectTab(0)
  end
  local isOutLaw = false
  local isUserAlliance = false
  local USER_ALLIANCE_FACTION_ID = 1000
  if alliance == OUTLAW_FACTION_ID then
    expedition.selectSponsor:Show(false)
    expedition.outlaw:Show(true)
    local info = GetOutLawInfo()
    expedition.outlaw.allianceId = info.id
    expedition.outlaw.sponsorName:SetText(info.name)
    expedition.outlaw.sponsorExplanation:SetText(info.desc)
    expedition.outlaw.icon:SetTextureInfo(info.key)
    expedition:SetExtent(EXPEDITION_WIDTH, EXPEDITION_OUTLAW_HEIGHT)
    expedition:SetTitle(locale.expedition.outlaw_title)
    isOutLaw = true
    tab:SelectTab(0)
  elseif alliance == NUIA_FACTION_ID then
    expedition.selectSponsor:Show(true)
    expedition.outlaw:Show(false)
    InitSponsorsTab(GetNuiaAllianceInfo())
    expedition:SetExtent(EXPEDITION_WIDTH, EXPEDITION_HEIGHT)
    expedition:SetTitle(locale.expedition.title)
    tab:SelectTab(1)
  elseif alliance == HARIHARA_FACTION_ID then
    expedition.selectSponsor:Show(true)
    expedition.outlaw:Show(false)
    InitSponsorsTab(GetHariharaAllianceInfo())
    expedition:SetExtent(EXPEDITION_WIDTH, EXPEDITION_HEIGHT)
    expedition:SetTitle(locale.expedition.title)
    tab:SelectTab(1)
  elseif alliance >= USER_ALLIANCE_FACTION_ID then
    expedition.selectSponsor:Show(false)
    expedition.outlaw:Show(false)
    expedition:SetExtent(EXPEDITION_WIDTH, EXPEDITION_USER_ALLIANCE_HEIGHT)
    expedition:SetTitle(locale.expedition.title)
    isUserAlliance = true
    tab:SelectTab(0)
  else
    return false
  end
  expedition.cmd.expeditionName:SetText("")
  return true, isOutLaw, isUserAlliance
end
