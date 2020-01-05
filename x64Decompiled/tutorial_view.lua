local WND_MIN_WIDTH = 215
local WND_MAX_WIDTH = tutorialLocale.width.window
local inset = {
  left = 40,
  right = 55,
  bottom = -30,
  content_text_right = 110,
  title_between_content = 10,
  text_between_icon = 20,
  not_icon_right = 20
}
local ICON_FRAME_WIDTH = 95
local function CreateConentsText(frame, explanationText, iconInfo)
  if explanationText == nil or string.len(explanationText) == 0 then
    UIParent:LogAlways(string.format("[WARNNING] CreateConentsText().. empty explanation text~!"))
    return nil
  end
  local function GetTextBox()
    if frame.explanationText ~= nil then
      return frame.explanationText
    else
      local msg = frame:CreateChildWidget("textbox", "explanationText", 0, true)
      return msg
    end
  end
  local msg = GetTextBox()
  local iconWidth = iconInfo ~= nil and iconInfo.coords[3] or 0
  local frameWidth, _ = frame:GetExtent()
  if iconWidth == 0 or iconWidth == nil then
    msg:SetExtent(frameWidth - inset.not_icon_right, 20)
  else
    msg:SetExtent(frameWidth - inset.content_text_right, 20)
  end
  msg:AddAnchor("TOPLEFT", frame, 0, 0)
  msg:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  msg.style:SetSnap(true)
  msg.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(msg, FONT_COLOR.BLACK)
  local explanation = X2Locale:LocalizeUiText(TUTORIAL_TEXT, explanationText)
  msg:SetText(explanation)
  local textHeight = msg:GetTextHeight()
  if iconWidth == 0 or iconWidth == nil then
    msg:SetExtent(msg:GetWidth(), textHeight + 5)
  else
    msg:SetExtent(msg:GetWidth(), textHeight)
  end
  return msg
end
function SetViewofTutorialWindow(id)
  local wnd = CreateEmptyWindow(id, "UIParent")
  wnd:Show(false)
  wnd:AddAnchor("BOTTOM", "UIParent", 0, -80)
  wnd:SetExtent(WND_MAX_WIDTH, 100)
  wnd:SetCloseOnEscape(false)
  wnd:EnableHidingIsRemove(true)
  wnd:SetSounds("tutorial")
  wnd:SetCloseOnEscape(true)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.TUTORIAL, "bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", wnd, -10, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 50, 0)
  local titleBar = CreateTitleBar(wnd:GetId() .. ".titleBar", wnd)
  titleBar.closeButton:RemoveAllAnchors()
  titleBar.closeButton:AddAnchor("TOPRIGHT", titleBar, -inset.right / 3, 12)
  titleBar:SetTitleInset(inset.left, 25, 0, 0)
  titleBar.titleStyle:SetAlign(ALIGN_LEFT)
  titleBar.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  ApplyButtonSkin(titleBar.closeButton, BUTTON_HUD.TUTORIAL_CLOSE)
  ApplyTitleFontColor(titleBar, FONT_COLOR.BLACK)
  wnd.titleBar = titleBar
  local bottomFrame = wnd:CreateChildWidget("emptywidget", "bottomFrame", 0, true)
  bottomFrame:SetExtent(WND_MAX_WIDTH - (inset.left + inset.right), 20)
  bottomFrame:AddAnchor("BOTTOMLEFT", wnd, inset.left, inset.bottom)
  wnd.bottomFrame = bottomFrame
  wnd.contentsFrameTable = {}
  local pageControl = W_CTRL.CreatePageControl(id .. ".pageControl", wnd, "tutorial")
  pageControl:Show(true)
  pageControl:AddAnchor("TOP", bottomFrame, "TOP", 0, -5)
  pageControl.firstPageButton:Show(false)
  pageControl.lastPageButton:Show(false)
  wnd.pageControl = pageControl
  local checkHideTutorial = CreateCheckButton(id .. ".checkHideTutorial", wnd, locale.tutorial.hideTutorial)
  checkHideTutorial:Show(false)
  checkHideTutorial:SetExtent(16, 18)
  checkHideTutorial:SetInset(16, 0, 0, 0)
  checkHideTutorial:AddAnchor("TOPLEFT", bottomFrame, 0, -5)
  checkHideTutorial.style:SetFontSize(13)
  checkHideTutorial.style:SetAlign(ALIGN_LEFT)
  checkHideTutorial:SetButtonStyle("tutorial")
  wnd.checkHideTutorial = checkHideTutorial
  local lineFrame = wnd:CreateChildWidget("emptywidget", "lineFrame", 0, true)
  lineFrame:SetExtent(WND_MAX_WIDTH - (inset.left + inset.right), 15)
  lineFrame:AddAnchor("BOTTOMLEFT", bottomFrame, "TOPLEFT", 0, 0)
  wnd.lineFrame = lineFrame
  local line = lineFrame:CreateDrawable(TEXTURE_PATH.TAB_LIST, "underline_1", "artwork")
  line:AddAnchor("LEFT", lineFrame, 0)
  line:AddAnchor("RIGHT", lineFrame, 0)
  function wnd:UpdateTutorialTitle(info, page)
    self.titleBar:SetTitleText(info.pageInfos[page].title)
  end
  local function GetContentsFrame(pageIndex, contentsIndex)
    if wnd.contentsFrameTable ~= nil and wnd.contentsFrameTable[pageIndex] ~= nil and wnd.contentsFrameTable[pageIndex][contentsIndex] ~= nil then
      return wnd.contentsFrameTable[pageIndex][contentsIndex]
    else
      local frame = wnd:CreateChildWidget("emptywidget", "contentsFrame", contentsIndex, true)
      return frame
    end
  end
  local GetIconFrame = function(parent, contentsIndex)
    if parent.iconFrame ~= nil and parent.iconFrame[contentsIndex] ~= nil then
      return parent.iconFrame[contentsIndex]
    else
      local frame = parent:CreateChildWidget("emptywidget", "iconFrame", contentsIndex, true)
      return frame
    end
  end
  local function InitContents()
    wnd.pageControl:Show(false)
    wnd.lineFrame:Show(false)
    wnd.bottomFrame:Show(false)
    if wnd.contentsFrameTable ~= nil then
      for i = 1, #wnd.contentsFrameTable do
        for j = 1, #wnd.contentsFrameTable[i] do
          local frame = wnd.contentsFrameTable[i][j]
          if frame ~= nil then
            frame:Show(false)
          end
        end
      end
    end
  end
  function wnd:CreateContentsPart(info)
    local totalPage = #info.pageInfos
    InitContents()
    if totalPage ~= 1 then
      wnd.pageControl:Show(true)
      wnd.pageControl:SetPageByItemCount(totalPage, 1)
      wnd.pageControl:SetCurrentPage(1, false)
      wnd.lineFrame:Show(true)
      wnd.bottomFrame:Show(true)
    end
    for pageIndex = 1, totalPage do
      wnd.contentsFrameTable[pageIndex] = {}
      for contentsIndex = 1, #info.pageInfos[pageIndex] do
        do
          local contentsInfo = info.pageInfos[pageIndex][contentsIndex]
          local prevFrame
          if contentsIndex > 1 then
            prevFrame = wnd.contentsFrameTable[pageIndex][contentsIndex - 1]
          end
          local frame = GetContentsFrame(pageIndex, contentsIndex)
          local anchorWidget = prevFrame == nil and wnd.titleBar or prevFrame
          local insetX = prevFrame == nil and inset.left or 0
          local insetY = prevFrame == nil and inset.title_between_content or 0
          frame:SetExtent(WND_MAX_WIDTH - (inset.left + inset.right), 10)
          frame:AddAnchor("TOPLEFT", anchorWidget, "BOTTOMLEFT", insetX, insetY)
          frame:Show(pageIndex == 1)
          local keyStr = MakeTutorialKey(info.id, pageIndex, contentsIndex)
          local iconInfo = tutorialToggleIcons[keyStr]
          local texPath = string.format("ui/tutorials/%s.dds", keyStr)
          local texKey = keyStr
          if iconInfo then
            texPath = TEXTURE_PATH.TUTORIAL
            texKey = "close_on"
          end
          local texInfo = UIParent:GetTextureData(texPath, texKey)
          if texInfo then
            if iconInfo == nil then
              iconInfo = {}
            end
            iconInfo.coords = texInfo.coords
          end
          frame.explanation = CreateConentsText(frame, contentsInfo.explanation, iconInfo)
          if iconInfo ~= nil then
            local iconFrame = GetIconFrame(frame, contentsIndex)
            iconFrame:SetExtent(ICON_FRAME_WIDTH, iconInfo.coords[4])
            iconFrame:AddAnchor("RIGHT", frame, "RIGHT", 0, 0)
            local icon
            local isButtonType = iconInfo.toggle ~= nil
            if isButtonType then
              if frame.iconButton == nil then
                icon = frame:CreateChildWidget("button", "iconButton", 0, true)
              else
                icon = frame.iconButton
              end
              if iconInfo.text ~= nil then
                icon:SetText(iconInfo.text)
              end
              ApplyButtonSkin(icon, BUTTON_BASIC.DEFAULT)
              icon:Show(true)
              function icon:OnClick()
                if iconInfo.toggle == "toggle_option" then
                  ToggleOptionFrame()
                else
                  X2Hotkey:ExcuteActionHandler(iconInfo.toggle)
                end
              end
              icon:SetHandler("OnClick", icon.OnClick)
            else
              if frame.iconImg == nil then
                icon = frame:CreateImageDrawable(texPath, "overlay")
              else
                icon = frame.iconImg
              end
              icon:SetVisible(true)
              icon:SetCoords(iconInfo.coords[1], iconInfo.coords[2], iconInfo.coords[3], iconInfo.coords[4])
              icon:SetExtent(iconInfo.coords[3], iconInfo.coords[4])
              icon:SetColor(1, 1, 1, 1)
              frame.iconImg = icon
            end
            if frame.iconFrame[contentsIndex] ~= nil then
              icon:AddAnchor("CENTER", frame.iconFrame[contentsIndex], 0, 0)
            end
            frame.icon = icon
          end
          local frameWidth, frameHeight = frame:GetExtent()
          local contentsHeight = frame.explanation:GetHeight()
          local iconHeight = iconInfo ~= nil and iconInfo.coords[4] or 0
          local resultHeight = math.max(contentsHeight, iconHeight)
          if frameHeight < resultHeight then
            frame:SetExtent(frameWidth, resultHeight)
          end
          wnd.contentsFrameTable[pageIndex][contentsIndex] = frame
        end
      end
    end
  end
  function wnd:UpdateWindowExtent()
    local longestHeight = 0
    for page = 1, #self.contentsFrameTable do
      local pageHeight = 0
      for index = 1, #self.contentsFrameTable[page] do
        local frame = self.contentsFrameTable[page][index]
        pageHeight = pageHeight + frame:GetHeight()
      end
      longestHeight = math.max(pageHeight, longestHeight)
    end
    local bottomHeight = wnd.bottomFrame:IsVisible() and wnd.bottomFrame:GetHeight() or 0
    local lineFrameHeight = lineFrame:IsVisible() and lineFrame:GetHeight() or 0
    local totalHeight = longestHeight + wnd.titleBar:GetHeight() + bottomHeight + -inset.bottom + inset.title_between_content + lineFrameHeight
    wnd:SetExtent(wnd:GetWidth(), totalHeight)
  end
  function wnd:UpdateWindowAnchor(tutorialId)
    local keyStr = tostring(tutorialId)
    local wndAnchorInfo = GetTutorialAnchorInfos(keyStr)
    if wndAnchorInfo then
      wnd:RemoveAllAnchors()
      wnd:AddAnchor(wndAnchorInfo[1], wndAnchorInfo[2], wndAnchorInfo[3], wndAnchorInfo[4], wndAnchorInfo[5])
    else
      wnd:RemoveAllAnchors()
      wnd:AddAnchor("BOTTOM", "UIParent", 0, -80)
    end
  end
  function wnd:ChangedPage(info, nowPage)
    self:UpdateTutorialTitle(info, nowPage)
    for pageIndex = 1, #self.contentsFrameTable do
      for contentsIndex = 1, #self.contentsFrameTable[pageIndex] do
        local frame = self.contentsFrameTable[pageIndex][contentsIndex]
        frame:Show(nowPage == pageIndex)
      end
    end
  end
  return wnd
end
