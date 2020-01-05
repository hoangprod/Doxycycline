function SetViewOfCommunity(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:SetExtent(900, 752)
  wnd:AddAnchor("CENTER", parent, 0, 0)
  wnd:SetTitle(GetCommonText("community"))
  wnd:SetSounds("community")
  wnd:SetCloseOnEscape(true)
  wnd:ApplyUIScale(false)
  local contentBtnFrame = wnd:CreateChildWidget("emptywidget", "contentBtnFrame", 0, true)
  contentBtnFrame:SetExtent(wnd:GetWidth() - sideMargin * 2, 55)
  contentBtnFrame:AddAnchor("TOPLEFT", wnd.titleBar, "BOTTOMLEFT", sideMargin, 0)
  local contentBtnStyles = {
    {
      skinInfo = BUTTON_CONTENTS.COMMUNITY_TAB_RELATION,
      text = locale.community.relationship
    },
    {
      skinInfo = BUTTON_CONTENTS.COMMUNITY_TAB_FAMILY,
      text = locale.community.family
    },
    {
      skinInfo = BUTTON_CONTENTS.COMMUNITY_TAB_EXPEDITION,
      text = locale.community.expedition
    },
    {
      skinInfo = BUTTON_CONTENTS.COMMUNITY_TAB_NATION,
      text = locale.community.faction
    }
  }
  local contentBtns = {}
  local btnSpace = 0
  for i = 1, #contentBtnStyles do
    local cotentBtn = wnd:CreateChildWidget("button", "contentBtn", i, true)
    ApplyButtonSkinTable(cotentBtn, contentBtnStyles[i].skinInfo)
    cotentBtn:SetText(contentBtnStyles[i].text)
    SetButtonFontColor(cotentBtn, GetCommunityButtonFontColor())
    if btnSpace == 0 then
      btnSpace = contentBtnFrame:GetWidth() - cotentBtn:GetWidth() * #contentBtnStyles
      btnSpace = btnSpace / (#contentBtnStyles - 1)
    end
    cotentBtn:AddAnchor("LEFT", contentBtnFrame, "LEFT", (i - 1) * (cotentBtn:GetWidth() + btnSpace), 0)
    table.insert(contentBtns, cotentBtn)
  end
  wnd.contentBtns = contentBtns
  local height = wnd:GetHeight() - (contentBtnFrame:GetHeight() + titleMargin + sideMargin)
  for i = 1, #contentBtnStyles do
    local contentFrames = wnd:CreateChildWidget("emptywidget", "contentFrames", i, true)
    contentFrames:SetExtent(contentBtnFrame:GetWidth(), height)
    contentFrames:AddAnchor("TOPLEFT", contentBtnFrame, "BOTTOMLEFT", 0, 0)
    contentFrames:Show(false)
  end
  return wnd
end
