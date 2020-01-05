local CreateBuildEffectScrollWnd = function(id, parent, child)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:AddAnchor("TOPLEFT", child, "BOTTOMLEFT", -5, 5)
  frame:SetExtent(child:GetWidth() + MARGIN.WINDOW_SIDE / 2, 110)
  local bg = CreateContentBackground(frame, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local scrollWnd = CreateScrollWindow(frame, frame:GetId() .. "scrollWnd", 0)
  scrollWnd:Show(true)
  scrollWnd:AddAnchor("TOPLEFT", frame, 0, 5)
  scrollWnd:AddAnchor("BOTTOMRIGHT", frame, -7, -5)
  frame.scrollWnd = scrollWnd
  local width = scrollWnd:GetWidth() - scrollWnd.scroll.vs:GetWidth() - MARGIN.WINDOW_SIDE / 2
  local buildEffect = scrollWnd.content:CreateChildWidget("textbox", "buildEffect", 0, true)
  buildEffect:Show(false)
  buildEffect:SetExtent(width, FONT_SIZE.MIDDLE)
  buildEffect.style:SetAlign(ALIGN_LEFT)
  buildEffect.style:SetSnap(true)
  ApplyTextColor(buildEffect, FONT_COLOR.MIDDLE_TITLE)
  return frame
end
local CreateBuildCondition = function(id, parent, child)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:AddAnchor("TOPLEFT", child, "BOTTOMLEFT", -5, 5)
  frame:SetExtent(child:GetWidth() + MARGIN.WINDOW_SIDE / 2, 100)
  local bg = CreateContentBackground(frame, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  return frame
end
function SetViewOfBuildCondition(id, parent)
  local width = POPUP_WINDOW_WIDTH
  local height = 544
  local frame = CreateWindow(id, parent)
  frame:AddAnchor("CENTER", parent, 0, 0)
  frame:SetExtent(width, height)
  frame:Show(true)
  local contentWidth = frame:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local buildName = frame:CreateChildWidget("textbox", "buildName", 0, true)
  buildName:AddAnchor("TOP", frame, "TOP", 0, 50)
  buildName:SetExtent(contentWidth, FONT_SIZE.LARGE)
  buildName.style:SetAlign(ALIGN_CENTER)
  buildName:SetAutoResize(true)
  buildName.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(buildName, FONT_COLOR.BLUE)
  local buildEffectDesc = frame:CreateChildWidget("textbox", "buildEffectDesc", 0, true)
  buildEffectDesc:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  buildEffectDesc.style:SetAlign(ALIGN_LEFT)
  buildEffectDesc:SetAutoResize(true)
  buildEffectDesc:AddAnchor("TOPLEFT", buildName, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE)
  ApplyTextColor(buildEffectDesc, FONT_COLOR.DEFAULT)
  local guide = W_ICON.CreateGuideIconWidget(buildEffectDesc)
  guide:AddAnchor("TOPRIGHT", buildEffectDesc, 0, -2)
  frame.guide = guide
  local buildEffectScrollWnd = CreateBuildEffectScrollWnd("buildEffectScrollWnd", frame, buildEffectDesc)
  local buildConditionDesc = frame:CreateChildWidget("textbox", "buildConditionDesc", 0, true)
  buildConditionDesc:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  buildConditionDesc.style:SetAlign(ALIGN_LEFT)
  buildConditionDesc:SetAutoResize(true)
  buildConditionDesc:AddAnchor("TOPLEFT", buildEffectScrollWnd, "BOTTOMLEFT", 0, 5)
  buildConditionDesc:SetText(GetCommonText("build_condition_progress"))
  ApplyTextColor(buildConditionDesc, FONT_COLOR.DEFAULT)
  local buildCondition = CreateBuildCondition("buildCondition", frame, buildConditionDesc)
  local iconBtn = CreateItemIconButton(frame:GetId() .. ".icon", frame)
  iconBtn:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  iconBtn:AddAnchor("TOP", buildCondition, 0, 20)
  local reqItemCount = frame:CreateChildWidget("textbox", "reqItemCount", 0, true)
  reqItemCount.style:SetAlign(ALIGN_CENTER)
  reqItemCount:AddAnchor("TOP", iconBtn, "BOTTOM", 0, 0)
  reqItemCount:SetExtent(frame:GetWidth(), DEFAULT_SIZE.EDIT_HEIGHT)
  ApplyTextColor(reqItemCount, FONT_COLOR.DEFAULT)
  local buildExplanationDesc = frame:CreateChildWidget("textbox", "buildExplanationDesc", 0, true)
  buildExplanationDesc:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  buildExplanationDesc.style:SetAlign(ALIGN_CENTER)
  buildExplanationDesc:SetAutoResize(true)
  buildExplanationDesc:AddAnchor("TOP", buildCondition, "BOTTOM", 5, MARGIN.WINDOW_SIDE / 2 + 2)
  ApplyTextColor(buildExplanationDesc, FONT_COLOR.BLUE)
  local okBtn = frame:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:AddAnchor("TOP", buildExplanationDesc, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  okBtn:SetText(GetCommonText("ok"))
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  local function SetFrameHeight()
    local height = MARGIN.WINDOW_TITLE + MARGIN.WINDOW_SIDE + 20 + buildName:GetHeight() + buildEffectDesc:GetHeight() + buildConditionDesc:GetHeight() + buildCondition:GetHeight() + buildExplanationDesc:GetHeight() + okBtn:GetHeight() + MARGIN.WINDOW_SIDE + MARGIN.WINDOW_TITLE * 3
    frame:SetHeight(height)
  end
  local function SetItemIcon(param)
    iconBtn:Show(false)
    if param.itemCount > 0 then
      local itemInfo = X2Item:GetItemInfoByType(param.itemType)
      iconBtn:Show(true)
      iconBtn:SetItemInfo(itemInfo)
      iconBtn:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      iconBtn:SetStack(string.format("%d", param.itemCount))
    end
  end
  local GetAnchorY = function(offset)
    if offset == 0 then
      return 0
    else
      return MARGIN.WINDOW_SIDE
    end
  end
  local function FillBuildEffect(widget, content, text)
    local yOffset = 11
    if text == nil or text == "" then
      widget:Show(false)
      return yOffset
    end
    widget:Show(true)
    widget:AddAnchor("TOPLEFT", content, 18, yOffset)
    widget:SetText(text)
    yOffset = yOffset + GetAnchorY(yOffset)
    widget:SetHeight(widget:GetTextHeight())
    widget:SetWidth(content:GetWidth() - 18)
    yOffset = yOffset + widget:GetTextHeight()
    return yOffset
  end
  local function ResetBuildCondition(count, laststep)
    local height = 60
    if laststep == true then
      height = 0
      buildCondition:Show(false)
      reqItemCount:Show(false)
      buildConditionDesc:SetHeight(0)
      buildConditionDesc:AddAnchor("TOPLEFT", buildEffectScrollWnd, "BOTTOMLEFT", 0, 0)
      buildConditionDesc:Show(false)
    else
      buildConditionDesc:SetHeight(FONT_SIZE.MIDDLE)
      buildConditionDesc:AddAnchor("TOPLEFT", buildEffectScrollWnd, "BOTTOMLEFT", 5, MARGIN.WINDOW_SIDE / 2)
      buildConditionDesc:Show(true)
      buildCondition:Show(true)
      reqItemCount:Show(true)
    end
    if count > 0 then
      buildCondition:SetHeight(100)
      reqItemCount:AddAnchor("TOP", iconBtn, "BOTTOM", 0, 0)
    else
      buildCondition:SetHeight(height)
      reqItemCount:AddAnchor("TOP", buildCondition, 0, 15)
    end
  end
  function frame:FillData(param)
    self.buildEffectDesc:SetText(GetCommonText(param.effectDesc))
    self.buildName:SetText(param.name)
    SetItemIcon(param)
    local setItemCount = string.format("%s%d%s/%d", FONT_COLOR_HEX.BLUE, param.devoteItemCount, FONT_COLOR_HEX.DEFAULT, param.reqItemCount)
    self.reqItemCount:SetText(setItemCount)
    self.buildEffectScrollWnd.scrollWnd:ResetScroll(0)
    local yOffset = FillBuildEffect(self.buildEffectScrollWnd.scrollWnd.content.buildEffect, self.buildEffectScrollWnd.scrollWnd.content, param.buildEffect)
    local scrollRange = self.buildEffectScrollWnd.scrollWnd:ResetScroll(yOffset)
    self.buildEffectScrollWnd.scrollWnd.scroll:Show(scrollRange > 0)
    ResetBuildCondition(param.itemCount, param.isLastStep)
    self.buildExplanationDesc:SetText(param.buildExplanation)
    if param.tooltip == nil or param.tooltip == "" then
      self.guide:Show(false)
    else
      self.guide:Show(true)
      local function OnEnter(guideself)
        SetTooltip(param.tooltip, guideself)
      end
      self.guide:SetHandler("OnEnter", OnEnter)
    end
    SetFrameHeight()
  end
  return frame
end
