function SetViewBanner(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", 0, 130)
  frame.selectedInstance = nil
  frame.selectedInstanceUiKindType = nil
  function frame:MakeOriginWindowPos(reset)
    if frame == nil then
      return
    end
    frame:RemoveAllAnchors()
    frame:SetExtent(239, 94)
    if reset then
      frame:AddAnchor("TOPRIGHT", parent, F_LAYOUT.CalcDontApplyUIScale(-305), 0)
    else
      frame:AddAnchor("TOPRIGHT", parent, -305, 0)
    end
  end
  frame:MakeOriginWindowPos()
  local bg = frame:CreateDrawable(TEXTURE_PATH.BANNER_GOLDEN_PLAINS, "banner", "background")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  frame.bg = bg
  local title = frame:CreateChildWidget("textbox", "title", 0, true)
  title:SetExtent(205, 20)
  title:SetAutoResize(true)
  title:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  title.style:SetShadow(true)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title:AddAnchor("TOPLEFT", frame, "TOPLEFT", 14, 19)
  ApplyTextColor(title, FONT_COLOR.MEDIUM_YELLOW)
  local desc = frame:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetExtent(165, 20)
  desc:SetAutoResize(true)
  desc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  desc.style:SetShadow(true)
  desc.style:SetAlign(ALIGN_LEFT)
  desc.style:SetFontSize(FONT_SIZE.MIDDLE)
  desc:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 5)
  desc:SetText(GetCommonText("banner_desc"))
  ApplyTextColor(desc, FONT_COLOR.WHITE)
  local detailBtn = frame:CreateChildWidget("button", "detailBtn", 0, true)
  detailBtn:SetExtent(225, 15)
  detailBtn.style:SetAlign(ALIGN_RIGHT)
  detailBtn.style:SetFontSize(FONT_SIZE.SMALL)
  detailBtn:SetText(GetCommonText("warring_desc"))
  detailBtn:AddAnchor("TOPLEFT", frame, "BOTTOMLEFT", 6, -22)
  local dragWindow = frame:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", frame, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  dragWindow:EnableDrag(true)
  local exitBtn = frame:CreateChildWidget("button", "exitBtn", 0, true)
  exitBtn:SetExtent(12, 12)
  ApplyButtonSkin(exitBtn, BUTTON_BASIC.BANNER_EXIT)
  exitBtn:AddAnchor("TOPRIGHT", frame, "TOPRIGHT", -5, 3)
  function frame:SetData(instanceType)
    if instanceType == nil then
      return false
    end
    local info = X2BattleField:GetBannerInfo(instanceType)
    if info == nil then
      return false
    end
    self.title:SetText(info.name)
    self.bg:SetTexture(string.format("ui/hud/banner/%s.dds", info.zoneName))
    self.bg:SetTextureInfo("banner")
    self.selectedInstance = instanceType
    self.selectedInstanceUiKindType = info.instanceUiKindType
    self:SetHeight(63 + self.title:GetHeight() + self.desc:GetHeight())
    return true
  end
  function frame:ShowBannerClosedWarringDlg()
    local DialogHandler = function(wnd)
      function wnd:OkProc()
        X2BattleField:OffBanner()
      end
      wnd:SetTitle(GetCommonText("warring"))
      wnd:SetContent(GetCommonText("banner_detail"))
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, self:GetId())
  end
  return frame
end
