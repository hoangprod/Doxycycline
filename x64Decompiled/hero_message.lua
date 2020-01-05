local heroMessage
local function CreateHeroMessage(id, parent)
  local frame = CreateCenterMessageFrame("heroMessage", parent, "TYPE4")
  frame:EnableHidingIsRemove(true)
  frame.body:SetHeight(FONT_SIZE.MIDDLE)
  frame.body.style:SetFontSize(FONT_SIZE.MIDDLE)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  frame.title:SetAutoResize(true)
  frame.title:SetHeight(FONT_SIZE.XLARGE)
  frame.title.style:SetFontSize(FONT_SIZE.XLARGE)
  local function DeafultSmallLayount(title, desc)
    frame.icon:SetVisible(true)
    frame.icon:RemoveAllAnchors()
    frame.icon:AddAnchor("CENTER", frame.iconBg, -5, 2)
    frame.textImg:SetVisible(false)
    frame.iconBg:SetVisible(true)
    frame.bg:SetTexture(TEXTURE_PATH.ALARM_DECO)
    frame.bg:SetCoords(0, 0, 782, 128)
    frame.bg:SetExtent(625.60004, 102.4)
    frame.bg:RemoveAllAnchors()
    frame.bg:AddAnchor("BOTTOM", frame, 0, 0)
    frame.title:AddAnchor("TOP", frame.iconBg, "BOTTOM", 0, -2)
    frame.title:SetText(title)
    frame.title:Show(true)
    frame.body:RemoveAllAnchors()
    frame.body:AddAnchor("TOP", frame.title, "BOTTOM", 0, 7)
    frame.body:SetTextAutoWidth(1000, desc, 5)
    frame.body:SetHeight(frame.body:GetTextHeight())
  end
  function frame:FillHeroElectionDayAlert(title, desc)
    ApplyTextColor(frame.title, F_COLOR.GetColor("original_dark_orange", false))
    ApplyTextColor(frame.body, FONT_COLOR.WHITE)
    DeafultSmallLayount(title, desc)
    frame.icon:SetTexture(TEXTURE_PATH.HERO_ELECTION_DAY_ALERT_MSG)
    frame.icon:SetTextureInfo("vote")
    frame:SetHandler("OnUpdate", frame.OnUpdate)
  end
  function frame:FillHeroElectionResult(title, desc)
    frame.icon:SetVisible(false)
    frame.iconBg:SetVisible(false)
    frame.bg:SetTexture(TEXTURE_PATH.HERO_ELECTION_RESULT_ICON)
    frame.bg:SetTextureInfo("trophy")
    frame.bg:RemoveAllAnchors()
    frame.bg:AddAnchor("TOP", frame, 0, -80)
    frame.textImg:SetVisible(true)
    frame.textImg:RemoveAllAnchors()
    frame.textImg:AddAnchor("TOP", frame.bg, "CENTER", 0, 15)
    frame.textImg:SetTexture(TEXTURE_PATH.HERO_ELECTION_RESULT_ICON)
    frame.textImg:SetTextureInfo("hero_text")
    ApplyTextColor(frame.title, F_COLOR.GetColor("original_dark_orange", false))
    ApplyTextColor(frame.body, FONT_COLOR.WHITE)
    frame.title:AddAnchor("TOP", frame.textImg, "BOTTOM", 0, 0)
    frame.title:SetText(title)
    frame.title:Show(true)
    frame.body:RemoveAllAnchors()
    frame.body:AddAnchor("TOP", frame.title, "BOTTOM", 0, 7)
    frame.body:SetTextAutoWidth(1000, desc, 5)
    frame.body:SetHeight(frame.body:GetTextHeight())
    frame:SetHandler("OnUpdate", frame.OnUpdate)
  end
  function frame:FillHeroCandidateAlert(title, desc)
    local color = {
      ConvertColor(50),
      ConvertColor(201),
      ConvertColor(233),
      1
    }
    ApplyTextColor(frame.title, color)
    ApplyTextColor(frame.body, color)
    DeafultSmallLayount(title, desc)
    frame.icon:SetTexture(TEXTURE_PATH.HERO_CANDIDATE_ALERT_MSG)
    frame.icon:SetTextureInfo("hero_candidate")
    frame:SetHandler("OnUpdate", frame.OnUpdate)
  end
  function frame:FillHeroElectionAlert(title, desc)
    local color = {
      ConvertColor(50),
      ConvertColor(201),
      ConvertColor(233),
      1
    }
    ApplyTextColor(frame.title, color)
    ApplyTextColor(frame.body, color)
    DeafultSmallLayount(title, desc)
    frame.icon:SetTexture(TEXTURE_PATH.HERO_ELECTION_ALERT_MSG)
    frame.icon:SetTextureInfo("hero_election")
    frame:SetHandler("OnUpdate", frame.OnUpdate)
  end
  function frame:FillHeroLeadershipRankingEnd(title, desc)
    local color = {
      ConvertColor(50),
      ConvertColor(201),
      ConvertColor(233),
      1
    }
    ApplyTextColor(frame.title, color)
    ApplyTextColor(frame.body, color)
    DeafultSmallLayount(title, desc)
    frame.icon:SetTexture(TEXTURE_PATH.HERO_LEADERSHIP_RANKING_END_MSG)
    frame.icon:SetTextureInfo("hero_leadership")
    frame:SetHandler("OnUpdate", frame.OnUpdate)
  end
  local function OnEndFadeOut()
    heroMessage = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowHeroMessage(EVENT_TYPE, title, desc)
  if not X2Player:GetFeatureSet().hero then
    return false
  end
  if heroMessage == nil then
    heroMessage = CreateHeroMessage("heroMessage", "UIParent")
  else
    return false
  end
  if EVENT_TYPE == "HERO_SEASON_OFF" then
    heroMessage:FillHeroLeadershipRankingEnd(title, desc)
  elseif EVENT_TYPE == "HERO_CANDIDATES_ANNOUNCED" then
    heroMessage:FillHeroCandidateAlert(title, desc)
  elseif EVENT_TYPE == "HERO_CANDIDATE_NOTI" then
    heroMessage:FillHeroElectionAlert(title, desc)
  elseif EVENT_TYPE == "HERO_ELECTION_RESULT" then
    heroMessage:FillHeroElectionResult(title, desc)
  elseif EVENT_TYPE == "HERO_NOTI" then
    heroMessage:FillHeroElectionAlert(title, desc)
  elseif EVENT_TYPE == "HERO_ELECTION_DAY_ALERT" then
    heroMessage:FillHeroElectionDayAlert(title, desc)
  else
    return false
  end
  heroMessage:Show(true)
  return true
end
