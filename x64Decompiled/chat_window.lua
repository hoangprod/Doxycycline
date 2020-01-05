local lastPopupParent
local function OnHidedPopup(popup)
  if lastPopupParent ~= nil then
    lastPopupParent:UseDynamicDrawableState("background", true)
    lastPopupParent:UseDynamicDrawableState("artwork", true)
    lastPopupParent:UseDynamicDrawableState("overlay", true)
    lastPopupParent = nil
  end
end
function OnContextChatTab(chatMessage, tabButton, chatTabId)
  lastPopupParent = chatMessage:GetParent()
  lastPopupParent:UseDynamicDrawableState("background", false)
  lastPopupParent:UseDynamicDrawableState("artwork", false)
  lastPopupParent:UseDynamicDrawableState("overlay", false)
  PopupChatTabContext(chatMessage, tabButton, chatTabId, OnHidedPopup)
end
function OnClickedChatTabAddButton(windowId)
  function AddTabProcedure(text)
    return X2Chat:AddNewChatTabByUser(windowId, text)
  end
  ShowCreateChatTabName(windowId)
  return true
end
function OnCreateChatWindow(chatWindow)
  chatWindow:SetOffset(0)
  chatWindow:SetTabWidth(chatLocale.chatTabWidth)
  chatWindow:SetMinTabWidth(42)
  chatWindow:SetTabAreaHeight(30)
  chatWindow:SetCaretOffset(0, 5)
  chatWindow:UseAutoResizingTabButtonMode(true)
  chatWindow:SetMinResizingExtent(345, 160)
  chatWindow:SetMaxResizingExtent(650, 620)
  chatWindow:SetTabAreaInset(0, 0, 10, 0)
  chatWindow:UseResizing(true)
  local locker = chatWindow:GetLockNotifyDrawable()
  locker:SetTexture(TEXTURE_PATH.HUD)
  locker:SetCoords(692, 94, 20, 30)
  locker:SetExtent(20, 30)
  chatWindow:SetMaxNotifyTime(3000)
  chatWindow:SetNotifyBlinkingFreq(400)
  local caret = chatWindow:GetCaretDrawable()
  caret:SetTexture(TEXTURE_PATH.HUD)
  caret:SetCoords(635, 130, 19, 14)
  caret:SetExtent(19, 14)
  local leftLine = chatWindow:GetLeftLineDrawable()
  leftLine:SetTexture(TEXTURE_PATH.DEFAULT)
  leftLine:SetExtent(0, 1)
  leftLine:SetCoords(992, 200, 32, 1)
  chatWindow:SetLeftLineOffset(0)
  local rightLine = chatWindow:GetRightLineDrawable()
  rightLine:SetTexture(TEXTURE_PATH.DEFAULT)
  rightLine:SetExtent(0, 1)
  rightLine:SetCoords(992, 198, 32, 1)
  chatWindow:SetRightLineOffset(0)
  local addButton = chatWindow:GetAddButton()
  ApplyButtonSkin(addButton, BUTTON_HUD.CHAT_ADD_TAB)
  local imeToggleBtn = chatWindow:GetImeToggleButton()
  ApplyButtonSkin(imeToggleBtn, BUTTON_HUD.IME_KOREA)
  imeToggleBtn:RemoveAllAnchors()
  imeToggleBtn:AddAnchor("LEFT", chatWindow:GetChatEdit(), "RIGHT", 0, 1)
  function imeToggleBtn:UpdateImeMode()
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage == "English" then
      ChangeButtonSkin(imeToggleBtn, BUTTON_HUD.IME_ENGLISH)
    else
      ChangeButtonSkin(imeToggleBtn, BUTTON_HUD.IME_KOREA)
    end
  end
  function imeToggleBtn:OnClick()
    chatWindow:GetChatEdit():SetFocus()
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage ~= "English" then
      X2Input:SetInputLanguage("English")
    else
      X2Input:SetInputLanguage("Native")
    end
    self:UpdateImeMode()
  end
  imeToggleBtn:SetHandler("OnClick", imeToggleBtn.OnClick)
  function imeToggleBtn:OnEvent(event)
    self:UpdateImeMode()
  end
  imeToggleBtn:SetHandler("OnEvent", imeToggleBtn.OnEvent)
  imeToggleBtn:RegisterEvent("IME_STATUS_CHANGED")
  imeToggleBtn:UpdateImeMode()
  local urlBtn = chatWindow:GetUrlButton()
  ApplyButtonSkin(urlBtn, BUTTON_HUD.URL_BUTTON)
  function urlBtn:OnClick()
    ShowUrlLinkWindow("urlLink", "UIParent")
  end
  urlBtn:SetHandler("OnClick", urlBtn.OnClick)
  local urlBtnOnEnter = function(self)
    SetTooltip(GetCommonText("url_icon_tooltip"), self)
  end
  urlBtn:SetHandler("OnEnter", urlBtnOnEnter)
  local edit = chatWindow:GetChatEdit()
  edit:SetCursorColor(EDITBOX_CURSOR.WHITE[1], EDITBOX_CURSOR.WHITE[2], EDITBOX_CURSOR.WHITE[3], EDITBOX_CURSOR.WHITE[4])
  edit:SetHeight(DEFAULT_SIZE.CHAT_EDIT_HEIGHT)
  edit:SetInset(chatLocale.chatTypeExtent.w + 5, 0, 5, 0)
  edit:RemoveAllAnchors()
  edit:AddAnchor("TOPLEFT", chatWindow, "BOTTOMLEFT", 2, 2)
  edit:AddAnchor("RIGHT", chatWindow, "RIGHT", -47, 0)
  edit:SetMaxTextLength(chatLocale.maxTextLength)
  local restrictLabel = edit:CreateChildWidget("label", "restrictLabel", 0, true)
  restrictLabel:Show(false)
  restrictLabel:SetHeight(23)
  restrictLabel:SetAutoResize(true)
  restrictLabel:AddAnchor("LEFT", edit, 85, 0)
  restrictLabel:SetText(X2Locale:LocalizeUiText(RESTRICT_TEXT, "restrict_info"))
  ApplyTextColor(restrictLabel, FONT_COLOR.PURE_RED)
  function edit:OnAcceptFocus()
    local keyboardLayout = X2Locale:GetKeyboardLayout()
    imeToggleBtn:Show(keyboardLayout == "KOREAN" or keyboardLayout == "JAPANESE")
    local enableChat = X2Player:IsEnableChat()
    restrictLabel:Show(not enableChat)
    urlBtn:Show(true)
  end
  edit:SetHandler("OnAcceptFocus", edit.OnAcceptFocus)
  function edit:OnTextChanged()
    if string.len(edit:GetText()) > 0 then
      restrictLabel:Show(false)
    end
  end
  edit:SetHandler("OnTextChanged", edit.OnTextChanged)
  DrawChatEditBackground(edit)
  edit:SetPrefixInset(0, 0, 5, 0)
  edit.prefixStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  edit.prefixStyle:SetSnap(true)
  edit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  edit.style:SetSnap(true)
  local chatTypeButton = chatWindow:GetChatMethodSelector()
  chatTypeButton:SetExtent(chatLocale.chatTypeExtent.w, chatLocale.chatTypeExtent.h)
  chatTypeButton:RemoveAllAnchors()
  chatTypeButton:AddAnchor("LEFT", edit, 0, 0)
  chatTypeButton:SetInset(31, 0, 0, 0)
  chatTypeButton.style:SetAlign(ALIGN_LEFT)
  chatTypeButton.style:SetShadow(ALIGN_LEFT)
  chatTypeButton:SetTextColor(1, 1, 1, 1)
  chatTypeButton.icon = chatTypeButton:CreateDrawable(TEXTURE_PATH.HUD, "white_balloon", "artwork")
  chatTypeButton.icon:AddAnchor("LEFT", chatTypeButton, 3, -1)
  local costWnd = edit:CreateChildWidget("textbox", "costWnd", 0, true)
  costWnd:SetExtent(100, edit:GetHeight())
  costWnd:SetInset(0, 0, 5, 0)
  costWnd:AddAnchor("RIGHT", edit, 0, 0)
  costWnd.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(costWnd, FONT_COLOR.WHITE)
  costWnd:Show(false)
  function costWnd:SetValue(str, len)
    if str ~= nil then
      costWnd:SetWidth(200)
      costWnd:SetText(str)
      local width = costWnd:GetLongestLineWidth() + 5
      costWnd:SetWidth(width)
      edit:SetInset(30 + len + 10, 0, 5 + width, 0)
      costWnd:Show(true)
    else
      edit:SetInset(30 + len + 10, 0, 5, 0)
      costWnd:Show(false)
    end
  end
  CreateComboList(chatTypeButton)
  local init = true
  local lastChannel
  function chatTypeButton:OnContentUpdated(kind, arg1, arg2)
    local text = chatTypeButton:GetText()
    local len = chatTypeButton.style:GetTextWidth(text)
    chatTypeButton:SetExtent(len + 38, 23)
    if init then
      init = false
      local chatComboList = chatTypeButton:GetList()
      local chCount = chatComboList:ItemCount()
      local size = chatComboList.itemStyle:GetLineHeight() + 3
      local height = chCount * size + 15
      chatComboList:SetExtent(chatLocale.chatComboListExtent.w, height)
    end
    local info = X2Chat:GetChatChannelInfo(arg2)
    local costStr, msgStr
    if info ~= nil and info.amount > 0 then
      if info.spendMoney then
        msgStr = MakeMoneyText(tostring(info.amount))
        costStr = string.format("|m%s;", info.amount)
      else
        msgStr = X2Item:GetItemLinkedTextByItemType(info.itemType)
        if msgStr ~= nil and info.amount > 1 then
          msgStr = string.format("%sX%d ", msgStr, info.amount)
        end
      end
    end
    if lastChannel ~= arg2 then
      costWnd:SetValue(costStr, len)
      if msgStr ~= nil then
        X2Chat:DispatchChatMessage(CMF_SYSTEM, FONT_COLOR_HEX.BATTLEFIELD_RED .. GetCommonText("notify_spend_for_chat", info.name, msgStr))
      end
      lastChannel = arg2
    end
  end
  chatTypeButton:SetHandler("OnContentUpdated", chatTypeButton.OnContentUpdated)
  return true
end
function CreateComboList(chatTypeButton)
  local chatComboList = chatTypeButton:GetList()
  chatComboList:RemoveAllAnchors()
  chatComboList:SetInset(0, 3, 0, 0)
  chatComboList:AddAnchor("BOTTOMLEFT", chatTypeButton, "TOPLEFT", 0, 7)
  chatComboList:SetExtent(chatLocale.chatComboListExtent.w, chatLocale.chatComboListExtent.h)
  local bg = chatComboList:CreateDrawable(TEXTURE_PATH.HUD, "list_chat_bg", "background")
  bg:AddAnchor("TOPLEFT", chatComboList, -1, -10)
  bg:AddAnchor("BOTTOMRIGHT", chatComboList, 1, 0)
  chatComboList.bg = bg
  chatComboList:SetHeight(3)
  chatComboList.itemStyle:SetAlign(ALIGN_LEFT)
  chatComboList.itemStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  chatComboList.itemStyle:SetSnap(true)
  chatComboList.itemStyle:SetShadow(true)
end
function OnSetChatTabId(chatTabButton, chatTabId)
  function chatTabButton:OnEnter()
    if chatTabId == nil or chatTabId == -1 then
      return
    end
    local tipInfo = X2Chat:GetChatTabInfoTable(chatTabId)
    if tipInfo ~= nil then
      SetVerticalTooltip(tipInfo.name, self)
    end
  end
  chatTabButton:SetHandler("OnEnter", chatTabButton.OnEnter)
  function chatTabButton:OnLeave()
    HideTooltip()
  end
  chatTabButton:SetHandler("OnLeave", chatTabButton.OnLeave)
end
function OnCreateChatTabButton(chatTabButton)
  ApplyButtonSkin(chatTabButton, BUTTON_HUD.CHAT_TAB_SELECTED)
  chatTabButton.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  chatTabButton:SetAutoClipChar(true)
  return true
end
function OnSelectedChatTab(chatTabButton, selected)
  if selected then
    ChangeButtonSkin(chatTabButton, BUTTON_HUD.CHAT_TAB_SELECTED)
  else
    ChangeButtonSkin(chatTabButton, BUTTON_HUD.CHAT_TAB_UNSELECTED)
  end
end
function OnCreateChatMessage(chatMessage)
  AddItemLinkHandlerToMessageWidget(chatMessage)
  chatMessage:SetMaxLines(300)
  chatMessage.style:SetAlign(ALIGN_LEFT)
  chatMessage.style:SetSnap(true)
  chatMessage.style:SetShadow(true)
  chatMessage.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  chatMessage:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  chatMessage:SetInset(35, 0, 10, 10)
  chatMessage:SetTimeVisible(120)
  chatMessage.bg = chatMessage:CreateDrawable(TEXTURE_PATH.HUD, "chat_message_bg", "background")
  chatMessage.bg:AddAnchor("TOPLEFT", chatMessage, 1, 0)
  chatMessage.bg:AddAnchor("BOTTOMRIGHT", chatMessage, 0, 0)
  local DrawFlickerEffect = function(widget)
    local effect_texture = widget:CreateEffectDrawable(TEXTURE_PATH.HUD, "overlay")
    effect_texture:SetVisible(false)
    effect_texture:SetCoords(841, 67, 28, 26)
    effect_texture:SetExtent(28, 26)
    effect_texture:AddAnchor("CENTER", widget, 0, 0)
    effect_texture:SetRepeatCount(0)
    effect_texture:SetEffectPriority(1, "alpha", 0.1, 0.1)
    effect_texture:SetEffectInitialColor(1, 1, 1, 1, 1)
    effect_texture:SetEffectFinalColor(1, 1, 1, 1, 1)
    effect_texture:SetEffectInterval(1, 0.2)
    effect_texture:SetEffectPriority(2, "alpha", 0.1, 0.1)
    effect_texture:SetEffectInitialColor(2, 1, 1, 1, 0)
    effect_texture:SetEffectFinalColor(2, 1, 1, 1, 0)
    effect_texture:SetEffectInterval(2, 0.2)
    widget.effect_texture = effect_texture
    function widget:ApplyFlickerEffect(isShow)
      self.effect_texture:SetStartEffect(isShow)
    end
  end
  DrawFlickerEffect(chatMessage:GetDownToBottomButton())
  function chatMessage:OnContentUpdated(arg)
    local button = chatMessage:GetDownToBottomButton()
    if arg == "read_chat_message" then
      button:ApplyFlickerEffect(false)
    elseif arg == "unread_chat_message" then
      button:ApplyFlickerEffect(true)
    end
  end
  chatMessage:SetHandler("OnContentUpdated", chatMessage.OnContentUpdated)
  local upBtn = chatMessage:GetUpButton()
  ApplyButtonSkin(upBtn, BUTTON_BASIC.SLIDER_UP)
  upBtn:RemoveAllAnchors()
  upBtn:AddAnchor("TOPLEFT", chatMessage, 5, 5)
  local downBtn = chatMessage:GetDownButton()
  ApplyButtonSkin(downBtn, BUTTON_BASIC.SLIDER_DOWN)
  downBtn:RemoveAllAnchors()
  downBtn:AddAnchor("BOTTOMLEFT", chatMessage:GetDownToBottomButton(), "TOPLEFT", 2, 0)
  local downToBottomBtn = chatMessage:GetDownToBottomButton()
  ApplyButtonSkin(downToBottomBtn, BUTTON_HUD.CHAT_SCROLL_DOWN_BOTTOM)
  downToBottomBtn:RemoveAllAnchors()
  downToBottomBtn:AddAnchor("BOTTOMLEFT", chatMessage, 3, -5)
  local slider = chatMessage:GetSlider()
  slider:RemoveAllAnchors()
  slider:SetWidth(17)
  slider:AddAnchor("TOP", upBtn, "BOTTOM", 0, 0)
  slider:AddAnchor("BOTTOM", downBtn, "TOP", 0, 0)
  local bg = slider:CreateDrawable(TEXTURE_PATH.SCROLL, "scroll_frame_bg", "artwork")
  bg:RemoveAllAnchors()
  bg:AddAnchor("TOPLEFT", slider, 2, -10)
  bg:AddAnchor("BOTTOMRIGHT", slider, -2, 8)
  local thumbButton = slider:GetThumbButtonWidget()
  ApplyButtonSkin(thumbButton, BUTTON_BASIC.SLIDER_VERTICAL_THUMB)
  thumbButton:AddAnchor("LEFT", slider, 5, 0)
  return true
end
local AddUISaveHandler = function(chatWindow, id, delayed)
  function chatWindow:ProcCorrectBound(info)
    if IsValidBoundInfo(info) == false then
      return
    end
    local bound = info.bound
    local screenWidth = UIParent:GetScreenWidth()
    local screenHeight = UIParent:GetScreenHeight()
    local screenRatio = screenHeight / info.screenResolution.y
    bound.y = bound.y * screenRatio
    local scale = UIParent:GetUIScale()
    local margin = 7 * scale
    local bottomMargin = 30 * scale
    bound.width = bound.width * scale
    bound.height = bound.height * scale
    if bound.x < 0 then
      bound.x = margin
    end
    if bound.y < 0 then
      bound.y = margin
    end
    if screenWidth < bound.width then
      bound.width = screenWidth - margin * 2
    end
    if screenHeight < bound.height then
      bound.height = screenHeight - (margin + bottomMargin)
    end
    if screenWidth < bound.x + bound.width then
      bound.x = screenWidth - (bound.width + margin)
    end
    if screenHeight < bound.y + bound.height then
      bound.y = screenHeight - (bound.height + bottomMargin)
    end
    self:RemoveAllAnchors()
    self:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(bound.x), F_LAYOUT.CalcDontApplyUIScale(bound.y))
    self:SetExtent(F_LAYOUT.CalcDontApplyUIScale(bound.width), F_LAYOUT.CalcDontApplyUIScale(bound.height))
  end
  function chatWindow:OnScale()
    AddUISaveHandlerByKey(string.format("chatWindow[%d]", id), self, true)
    self:ApplyLastWindowBound()
  end
  chatWindow:SetHandler("OnScale", chatWindow.OnScale)
  if delayed == false then
    AddUISaveHandlerByKey(string.format("chatWindow[%d]", id), chatWindow, true)
  end
end
function OnDuplicatedChatWindow(chatWindow, id)
  AddUISaveHandler(chatWindow, id, false)
end
function CreateChatTabWindow()
  local chatWindowIds = X2Chat:AllChatWindowIds()
  local tabWindows = {}
  local lastTab
  for i, id in pairs(chatWindowIds) do
    do
      local tab = UIParent:CreateWidget("chatwindow", "chatWindow[" .. i .. "]", "UIParent")
      function tab:MakeOriginWindowPos(reset)
        if tab == nil then
          return
        end
        self:RemoveAllAnchors()
        if reset then
          tab:AddAnchor("BOTTOMLEFT", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(-145))
        else
          tab:AddAnchor("BOTTOMLEFT", "UIParent", 0, -145)
        end
        tab:SetExtent(430, 350)
      end
      tab:MakeOriginWindowPos()
      tab:Show(true)
      tab:SetSlideTimeInDragging(150)
      tab:AllowTabSwitch(true)
      tab:SetResizingBorderSize(11, 11, 12, 12)
      tab:UseAddTabButton(true)
      tab:SetChatWindowId(id)
      local resizingControlTexture = tab:CreateDrawable(TEXTURE_PATH.HUD, "chat_window_resizing_control", "overlay")
      resizingControlTexture:AddAnchor("TOPRIGHT", tab, -4, 4)
      if lastTab ~= nil then
        tab:AddAnchor("BOTTOMLEFT", lastTab, "TOPLEFT", 0, -10)
        tab:SetExtent(430, 160)
      end
      AddUISaveHandler(tab, id, true)
      table.insert(tabWindows, tab)
      lastTab = tab
    end
  end
  return tabWindows
end
function OnResetAllChatWindow()
  local tabWindows = CreateChatTabWindow()
  if tabWindows[1] == nil then
    return
  end
  tabWindows[1]:RemoveAllAnchors()
  tabWindows[1]:AddAnchor("BOTTOMLEFT", "UIParent", 0, -145)
  tabWindows[1]:SetExtent(430, 350)
  AddUISaveHandler(tabWindows[1], 0, false)
  tabWindows[1]:SaveBound()
  if tabWindows[2] ~= nil then
    tabWindows[2]:RemoveAllAnchors()
    tabWindows[2]:AddAnchor("BOTTOMLEFT", tabWindows[1], "TOPLEFT", 0, -10)
    tabWindows[2]:SetExtent(430, 160)
    AddUISaveHandler(tabWindows[2], 1, false)
    tabWindows[2]:SaveBound()
  end
  return true
end
chatTabWindow = CreateChatTabWindow()
